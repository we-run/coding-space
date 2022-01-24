require(['config'], function () {
    console.log('bbbb');
    // Configuration loaded now, safe to do other require calls
    // that depend on that config.
    require(['page', 'react-dom'], function (page, ReactDOM) {
        console.log('>>>>>1111')
        // console.log(page)

        // setInterval(() => {
        // }, 1000);

        ReactDOM.render(page, document.getElementById('root'))

    })
});