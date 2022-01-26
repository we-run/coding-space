const nunjucks = require("nunjucks");
const chockidar = require("chokidar");

nunjucks.configure({ autoescape: true });
let results = nunjucks.renderString('Hello {{ username }}', { username: 'James' });
console.log(results);


// var env = nunjucks.configure(__dirname + '/views', { // 每次configure 就近生效
//     autoescape: this,
//     watch: false, // 监听文件变化 chokidar 在工作
//     tags: { // 自定tag
//         blockStart: '{%-',
//         blockEnd: '-%}',
//         variableStart: '<$',
//         variableEnd: '$>',
//         commentStart: '{#',
//         commentEnd: '#}'
//     }
// })

var env = nunjucks.configure(__dirname + '/views', { // 每次configure 就近生效
    autoescape: this,
    watch: false // 监听文件变化 chokidar 在工作
})


// 自定义过滤器，对最终输出进行操作
env.addFilter('shorten', (str, count) => {
    console.log("Filter shorten running : " + str);
    return str.slice(0, count || 5);
})


// 监听文件变化，进行实时输出
// chockidar.watch('.').on('change', (path, stats) => {
//     if (stats) { 
//         console.log(`File ${path} change size to ${stats.size}`)
//     }

//     // 渲染输出结果
//     var output = nunjucks.render('main.njk', {
//         title: 'this is title tester!',
//         body: {
//             display: true
//         }
//     })
//     console.log(output)
// })


// 渲染输出结果
var output = nunjucks.render('main.njk', {
    title: 'this is title tester!',
    body: {
        display: true
    }
})
console.log(output)








