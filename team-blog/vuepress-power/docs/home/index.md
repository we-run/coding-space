---
title: 您好，世界！
date: 2021-09-01
description: 首次加载Vuepress站点
head:
- - meta
  - name: foo
  - content: bar
- - link
  - rel: canonical
    href: foobar
---
Welcome to [Hexo](https://hexo.io/)! This is your very first post. Check [documentation](https://hexo.io/docs/) for more info. If you get any problems when using Hexo, you can find the answer in [troubleshooting](https://hexo.io/docs/troubleshooting.html) or you can ask me on [GitHub](https://github.com/hexojs/hexo/issues).

## Quick Start

### Create a new post

``` bash
$ hexo new "My New Post"
```

#### 创建文章纪实

1. 目录分布 - source 目录下分别存放 `./_draft` 、`_posts` 、`自定义页面命名的文件目录`
2. 新建文件， 三种方式
   - 草稿模式 ： 可以使用 `draft` 参数指定markdown文件创建模板来源（`./scaffolds/draft.md` 模板）
   - 单页面模式 ： 
   - 文章模式 ：
   - 以上模板，均可以指定自己的布局条件
3. `post_asset_folder`设置参数，开启 `Asset` 文件目录，管理多媒体文件内容
   - 开启资源目录，每次新建文件命令(`hexo new [layout] title`会自动为其创建一个文件夹，与文件名称一致)
   - 可以使用相对路径引用标签插件, 也可以通过`marked`选项开启markdown普通图片标记中使用相对目录，直接引用图片
4. 标签和分类别名的使用 : 如果配置的别名映射， 则地址栏，在显示标签和分类页面的时候，会使用别名进行标记URL
5. 调研查看模板引擎
   - [nunjucks](https://mozilla.github.io/nunjucks/)， [github](https://github.com/mozilla/nunjucks)
   - [jade]()
   - [swig]() 已废多年

More info: [Writing](https://hexo.io/docs/writing.html)

### Run server

``` bash
$ hexo server
```

More info: [Server](https://hexo.io/docs/server.html)

### Generate static files

``` bash
$ hexo generate
```

More info: [Generating](https://hexo.io/docs/generating.html)

### Deploy to remote sites

``` bash
$ hexo deploy
```

More info: [Deployment](https://hexo.io/docs/one-command-deployment.html)



## 计算机奠基者

1. John von Neumann
{% asset_link Joh_von_Neumann.gif %}
{% asset_img Joh_von_Neumann.gif %}