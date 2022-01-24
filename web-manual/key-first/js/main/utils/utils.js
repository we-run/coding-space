define([
    'require',
    'react',
    'react-dom'
], function(require, React, ReactDOM) {
    // 'use strict';
    
    console.log("utils ... ")
    function RE_UL(items) {
        let subs = []
        items.forEach(i => {
            subs.push(React.createElement('li', { class : 'item', key: i}, i))
        });
        const element = React.createElement('ul', { class: 'list-items' }, subs);
        return element;
    }
    
    return {
        re_ul : RE_UL
    }
});