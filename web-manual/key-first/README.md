

### 初始化一个html首页文件

### 分别下载以下依赖库

- https://unpkg.com/react@17/umd/react.development.js"

- https://unpkg.com/react-dom@17/umd/react-dom.development.js

- https://requirejs.org/docs/download.html#requirejs



### 配置 Reqire.js 
- 划分目录为
  ```txt
  - js
  | - main
  | - | - page.js
  | - | - react.js
  | - config.js
  | - require.js
  - node_modules
  ```

- 配置 Requre.js
1. index.html 中异步加载 require.js
2. 定义模块 page.js

### 安装Babel
npm install --save-dev requirejs-babel @babel/standalone babel-plugin-module-resolver-standalone






### issue

1. 配置JSX在非 `text/babel` 的 `script` 标签中，怎么渲染
2. AA
