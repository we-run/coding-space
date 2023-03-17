### 2022-08-31


1. 首次运行 ES，自动配置安全策略的过程，不能有 `discovery.seed_hosts` 配置项； 在启动ES后，获取了自动配置项的填充，可继续加入其他节点进入集群；如此这样，就可以先保证一个`master_eligible`节点先启动了；

2. 如果首次运行ES失败，一定要清理一下 data目录，再次运行，否则会启用已有设置？

3. 在正式使用ES之前，必须要对ES集群以及相关组件如Kibana、各种Beats做安全相关的配置工作，包括：各种需求下的认证、授权；

4. 📢 **注意 ： 在生产环境部署的ES集群，最好要将monitor的工作单独部署到一个ES集群，由于监控的数据量频繁且庞大，容易造成很大压力**；

5. 每个节点启动后，默认即确定一个角色为： `master-eligible`, 这些节点，可以参与选主流程，成为`master`节点；第一个启动的节点，会将自己选为`master`节点。其他角色有： `data-node` 保存分片数据、 `coordinate-node` 负责接收和返回数据请求；

   ![image-20220831181106810](/Volumes/DFQ/PAN/DEVSpace/DOIT/:Users:dongfuqiang:Library:Application Support:typora-user-images:image-20220831181106810.png)

6. 不同的节点，可以使用不同的硬件，保证资源合理分配

7. 集群的状态信息，各个节点都会保存，但是只有`master`节点，才能修改。

8. 关于分片： 主分片创建完成，不能更改，除非reindex

   - 设定分片，要做好容量、业务规划和设计，因为分片数量设置过小不能水平扩展；过大则容易over-sharding
   - 集群健康状态区分： `GET _cluster/health`
   - 文档的管理操作包括： `index`  - PUT 、 `create` -  PUT + ID或者POST + ES自动生成ID、`read` 、`update` 、 `delete`
   - index 和 update ，前者会删除原文档，然后整体覆盖，版本号+1

9. 批量操作数据 Bulk API ， 批量读取数据 mget, 批量搜索 _msearch

### 2022-09-01

1. 在ES中 term的含义？
2. 倒排索引的结构
   - 词典 - Term Dictionary
   - 倒排列表 （Posting List）- 由倒排索引项组成
     - 倒排索引项 （Posting Item） :
       - 文档ID
       - 词频 TF
       - 位置 position - 单次在文档中分词的位置，用于语句搜索（phrase query）
       - 偏移 offset - 记录单次的开始结束位置，实现高亮显示
   - 搜索
3. ES识别JSON文档，每个字段可以选择作为索引或者不做索引
4. Analysis ： 文本分析是吧全文本转换成一系列单次（term / toekn）
   - 分词器
     - 三部分 ： Chracter Filters - Tokenizer - Toekn Filters
     - `/_analyzer`
   - 

### 问题

1. JVM、内存、磁盘？
2. 文本分析（Text Analysis）在什么时候起作用的？
   - 索引阶段
   - 搜索阶段
3. 