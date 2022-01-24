

require.config({
    baseUrl: "js/main",
    paths: {
        config: '../config.js',
        es6: '../../node_modules/requirejs-babel/es6',
        es: 'es',
        react: 'react.development',
        'react-dom': 'react-dom.development',
        page: 'page',
        page1: './pages/page1',
        utils: './utils/utils',
        babel: '../../node_modules/@babel/standalone/babel.min',
        bpmr: '../../node_modules/babel-plugin-module-resolver-standalone/index'
    }
})