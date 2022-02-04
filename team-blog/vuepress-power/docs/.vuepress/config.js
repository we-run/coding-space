

module.exports = {
    lang: 'zh-CN',
    title: 'WE RUN',
    base: '/team',
    description: '这是我的第一个 VuePress 站点',

    locales: {

    },
    pagePatterns: [
        '**/*.md',
        '!.vuepress',
        // '!home',
        '!node_modules'
    ],
    debug: true,
    // 主题和它的配置, 接收主题名称、主题简称或主题的绝对路径
    theme: '@vuepress/theme-default',


    // host: '127.0.0.1',
    // port: 8081,


    // boudler: "", 
    themeConfig: {
        logo: 'https://avatars.githubusercontent.com/u/82074362?s=400&u=60ff469045f530540b1a87a5e49b167e3bdd58da&v=4',
        navbar: [
            '/README.md',
            {
                text: '首页',
                link: '/home',
            },
            {
                text: '兴趣组',
                children: ['/group/g1.md', '/group/g2.md']
            },
            {
                text: '标签常用',
                children: [
                    {
                        text: 'Linux',
                        link: '/tags/t1.md',
                        activeMatch: '/'
                    },
                    {
                        text: 'OS',
                        link: '/tags/t2.md'
                    }
                ]
            },
            {
                text: '编码空间',
                link: '/',
                children: [
                    { text: 'ai-tensorflow', link: 'READEME.md' },
                    { text: 'base-c_cpp', link: 'READEME.md' },
                    { text: 'base-golang', link: 'READEME.md' },
                    { text: 'base-java_kotlin_scala', link: 'READEME.md' },
                    { text: 'base-javascript', link: 'READEME.md' },
                    { text: 'base-lua', link: 'READEME.md' },
                    { text: 'base-php', link: 'READEME.md' },
                    { text: 'base-python', link: 'READEME.md' },
                    { text: 'base-ruby', link: 'READEME.md' },
                    { text: 'base-shell', link: 'READEME.md' },
                    { text: 'base-sql', link: 'READEME.md' },
                    { text: 'base-swift', link: 'READEME.md' },
                    { text: 'base-typescript', link: 'READEME.md' },
                    { text: 'builds-tool-cmake', link: 'READEME.md' },
                    { text: 'builds-tool-cocoapods', link: 'READEME.md' },
                    { text: 'builds-tool-fastlane', link: 'READEME.md' },
                    { text: 'builds-tool-gradle', link: 'READEME.md' },
                    { text: 'builds-tool-webpack', link: 'READEME.md' },
                    { text: 'ci_cd-gerrit', link: 'READEME.md' },
                    { text: 'ci_cd-gitlab_runner', link: 'READEME.md' },
                    { text: 'ci_cd-jenkins', link: 'READEME.md' },
                    { text: 'db-elasticstack', link: 'READEME.md' },
                    { text: 'db-mysql', link: 'READEME.md' },
                    { text: 'db-postgresql', link: 'READEME.md' },
                    { text: 'efficient-tools-alfred', link: 'READEME.md' },
                    { text: 'efficient-tools-git', link: 'READEME.md' },
                    { text: 'efficient-tools-v2ray', link: 'READEME.md' },
                    { text: 'efficient-tools-vim', link: 'READEME.md' },
                    { text: 'infra-aliyun', link: 'READEME.md' },
                    { text: 'infra-aws', link: 'READEME.md' },
                    { text: 'infra-hashicorp', link: 'READEME.md' },
                    { text: 'infra-runtime-env', link: 'READEME.md' },
                    { text: 'lib-ioproject-reactor', link: 'READEME.md' },
                    { text: 'lib-netty', link: 'READEME.md' },
                    { text: 'lib-zookeeper', link: 'READEME.md' },
                    { text: 'media-img_audio_video', link: 'READEME.md' },
                    { text: 'network-dn42', link: 'READEME.md' },
                    { text: 'network-dns', link: 'READEME.md' },
                    { text: 'network-vpn', link: 'READEME.md' },
                    { text: 'os-ios', link: 'READEME.md' },
                    { text: 'os-linux', link: 'READEME.md' },
                    { text: 'platform-electron', link: 'READEME.md' },
                    { text: 'platform-flutter', link: 'READEME.md' },
                    { text: 'platform-k8s', link: 'READEME.md' },
                    { text: 'platform-openresty', link: 'READEME.md' },
                    { text: 'source-code-shared', link: 'READEME.md' },
                    { text: 'team-blog', link: 'READEME.md' },
                    { text: 'web-css', link: 'READEME.md' },
                    { text: 'web-manual', link: 'READEME.md' },
                    { text: 'web-react', link: 'READEME.md' },
                    { text: 'web-server-nginx', link: 'READEME.md' },
                    { text: 'web-server-node', link: 'READEME.md' },
                    { text: 'web-server-spring_boot', link: 'READEME.md' },
                    { text: 'web-server-tomcat', link: 'READEME.md' },
                    { text: 'web-space', link: 'READEME.md' },
                    { text: 'web-template-ejs', link: 'READEME.md' },
                    { text: 'web-template-nunjucks', link: 'READEME.md' },
                    { text: 'web-vue', link: 'READEME.md' },
                    { text: 'workflow-ldap_confluence_jira', link: 'READEME.md' },
                ]
            }
        ]
    },


    plugins: [
        
    ]
}