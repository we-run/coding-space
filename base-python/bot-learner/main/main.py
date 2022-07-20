from multiprocessing import Pool
import os
import re
from fabric2 import Connection, Result
from invoke import Collection, Promise, Responder, task
import main.utils as my_utils
import time


@task
def prepare(c):
    print("CUR ")
    my_utils.GREEN_LOG(
        'PREPARE STAGES', 'Init connections to remote hosts ... ')
    for stage in c.pre_settings:
        my_utils.GREEN_LOG('...PREPARE STAGE...', 'Stage Description : {} >>> {}'.format(
            c.pre_settings.index(stage) + 1, stage['description']))
        for chain_step in stage['steps']:
            chain_step[len(chain_step) - 1]['conn'] = my_utils.create_conn_chain(chain_step)
            my_utils.GREEN_LOG('...PREPARE STEP...', '> Step description : {}'.format(
                stage['steps'].index(chain_step) + 1))
    my_utils.GREEN_LOG('PREPARE TASK', 'prepare done!')
    print('\n\n')


@task
def output(c):
    # print(my_utils.get_mac_address())
    pass


@task(output)
def build(c):
    print('Build Done!')


# download es version of input

@task
def download_es(c):
    for h in c.hosts:
        print(h)
    conn = Connection('localhost')

    def exsited():
        conn.run('ls -l | ')

    print('Starting check and download specify version of es...' + c.es.version)


# clean old runned es dir


@task
def clean_old(c):
    pass


# reconfig es


@task(clean_old)
def re_config_es(c):
    print('Check and reconfig es ...' + c.es.version)
    pass


@task(prepare)
def config(c):
    my_utils.GREEN_LOG(
        'MAIN START', 'PID {} Run Commands...'.format(os.getpid()))
    for stage in c.pre_settings:
        my_utils.GREEN_LOG('MAIN DOING > {} START'.format(__loc_index(c.pre_settings, stage)), stage['description'])
        process_pool = None
        for chain_step in stage.get('steps'):
            if process_pool is None and not stage.get('sync'):
                process_pool = Pool(processes=len(stage.get('steps')))
                print(f'enable async processes ... {len(stage.get("steps"))}')
                # pass
            my_utils.BLUE_LOG('{} START'.format(__loc_index(c.pre_settings, stage, chain_step)),
                              'No Step Description' if chain_step[len(chain_step) - 1].get('description') is None
                              else chain_step[len(chain_step) - 1].get('description')
                              )
            if process_pool is not None:
                print('>>> ASYNC EXCUTE >>> ')
                res = process_pool.apply_async(__run_todo, args=(chain_step,))
                res.get(timeout=100)
            else:
                print('>>> SYNC EXCUTE >>>')
                __run_todo(chain_step)
        if process_pool is not None:
            process_pool.close()
            process_pool.join()
        my_utils.RED_LOG('MAIN DOING STAGE {} DONE'.format(
            c.pre_settings.index(stage) + 1), '!!!')
    print('\n\n')


@task(prepare)
def start_es(c):
    print('Start es ...' + c.es.version)

    pass


@task(config)
def stop_es(c):
    pass


@task(config)
def restart_es(c):
    # $TO_KIB_HOME/bin/kibana &
    # $TO_ES_HOME/bin/elasticsearch -d
    pass


def __run_todo(steps):
    print("TODO RUN >>> {}".format(steps))
    watchers = my_utils.get_runner_auto_responder(__collect_auto_res(steps))
    step = steps[len(steps) - 1]
    conn = step.get('conn')
    pkey = step.get('pkey')
    actions = step.get('actions')
    if conn is not None:
        if pkey is not None:
            r = conn.run('echo $HOME', )
            if isinstance(r, Result) and r.ok:
                r = re.search(r'(\S+)', '{}'.format(r.tail('stdout', count=1)))
                ssh_dir = r.group(0) + '/.ssh'
                judge_shell = 'if [[ -f {}/{} ]];then echo 1; else echo 0; fi'.format(ssh_dir, os.path.basename(pkey))
                if '1' not in conn.run(judge_shell, ).tail('stdout', count=1):
                    print('>>> COPY LOCAL KEY FILES TO REMOTE HOME ... ')
                    conn.run('mkdir -p ' + ssh_dir)
                    conn.put(my_utils.GET_CONF_FILE_PATH(pkey), ssh_dir)
                    with open(my_utils.GET_CONF_FILE_PATH(pkey + '.pub')) as pub_key_f:
                        if pub_key_f is not None:
                            sftp = conn.sftp()
                            with sftp.open(ssh_dir + '/authorized_keys', 'w') as sf:
                                sf.write(pub_key_f.read())
                else:
                    print(' ERR !')
        __run_action(conn, actions, watchers)
    else:
        my_utils.RED_LOG('ERR', 'No existed connection for remote hosts!')


def __run_action(conn, actions, watchers):
    for action in actions:
        # env_shell = ''
        # if action.get('env') is not None:
        #     for ek, ev in action.get('env').items():
        #         env_shell = env_shell + ';' + (ek + '=' + ev)
        #     env_shell = 'export ' + env_shell[1:]
        # print('>>> ENV VAR : ' + env_shell)
        my_utils.BLUE_LOG(' >> ACTION START >> ', action.get('description'))
        if action.get('sh_raw') is not None:
            # sh = env_shell + ' && ' + action.get('sh_raw')
            # print('---------->>>>' + action.get('sh_raw'))
            r = conn.run(action.get('sh_raw'), env=action.get('env'), watchers=watchers)
            # promise = conn.run(action.get('sh_raw'), env=action.get('env'), watchers=watchers, , asynchronous=True)
            # r = promise.join()
            my_utils.BLUE_LOG('<<== RAW SHELL RES <<==', ' Response : {}'.format(r))
        if action.get('sh_file') is not None:
            conn.put(my_utils.GET_CONF_FILE_PATH(action.get('sh_file')), './')
            # r = conn.run('sh ./' + os.path.basename(action.get('sh_file')), env=action.get('env'), watchers=watchers)
            promise = conn.run('sh ./' + os.path.basename(action.get('sh_file')), env=action.get('env'),
                               watchers=watchers, asynchronous=True)
            r = promise.join()
            my_utils.BLUE_LOG('<<== FILE SHELL RES <<==', ' Response : {}'.format(r))
            # with open(my_utils.GET_CONF_FILE_PATH(action.get('sh_file'))) as shf:
            #     # r = conn.run(shf.read(), env=action.get('env'),  watchers=watchers)
            #     promise = conn.run(shf.read(), env=action.get('env'),, watchers=watchers, asynchronous=True)
            #     r = promise.join()
            #     my_utils.BLUE_LOG('<<== FILE SHELL RES <<==', ' Response : {}'.format(r))
        if action.get('local_sh_file') is not None:
            promise = conn.run('sh ' + my_utils.GET_CONF_FILE_PATH("./deploy/pre.sh"), env=action.get('env'),
                               watchers=watchers, asynchronous=True)
            r = promise.join()
            my_utils.BLUE_LOG('<<== LOCAL FILE SHELL RES <<==', ' Response : {}'.format(r))
        if action.get('config') is not None:
            print(my_utils.GET_CONF_FILE_PATH(action.get('config').get('INPUT_FILE')))
            sftp = conn.sftp()
            print(action.get('env').get('CONFIG_FILE'))
            rf = sftp.open(action.get('env').get('CONFIG_FILE'), 'w+')
            with open(my_utils.GET_CONF_FILE_PATH(action.get('config').get('INPUT_FILE'))) as conf:
                for cl in conf.readlines():
                    for ck, cv in action.get('config').items():
                        cl = cl.replace('$' + ck, cv)
                    rf.write(cl)
            my_utils.BLUE_LOG('<<== FILE CONFIG RES <<==', ' Response : {}'.format(sftp))
        if action.get('deliver') is not None:
            for art in action.get('deliver'):
                print('upload artifact ... ')
                conn.put(my_utils.GET_CONF_FILE_PATH(art), './')


def __collect_auto_res(chain):
    auto_res = {}
    for ch_unit in chain:
        if isinstance(ch_unit, dict) and ch_unit.get('auto_complete') is not None:
            auto_res = {**auto_res, **ch_unit.get('auto_complete')}
    return auto_res


def __loc_index(main, stage=None, step=None, action=None):
    if stage is not None:
        if step is not None:
            if action is not None:
                return 'Stage: {}/{} >Step: {}/{} > Action: {}/{}'.format(
                    main.index(stage) + 1, len(main),
                    stage['steps'].index(step) + 1, len(stage),
                    step['actions'].index(action) + 1, len(step)
                )
            else:
                return 'Stage: {}/{} >Step: {}/{}'.format(
                    main.index(stage) + 1, len(main),
                    stage['steps'].index(step) + 1, len(stage)
                )
        else:
            return 'Stage: {}/{}'.format(main.index(stage) + 1, len(main))
    else:
        return ''
