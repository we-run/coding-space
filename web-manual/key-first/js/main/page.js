define([
    'require',
    'babel',
    'es',
    'react',
    'react-dom',
    'bpmr',
    'page1',
    'utils'
], function(req, babel, myes, React, DOM, bpmr, page1, utils) {
    // 'use strict';

    console.log('[page]->req>>>', req);
    console.log('[page]->babel>>>', babel);
    console.log('[page]->es6>>>', myes());
    console.log('[page]->React>>>', React);
    console.log('[page]->ReactDOM>>>', DOM);
    console.log('[page]->bpmr>>>', bpmr);
    
    // return (
    //     <ul>
    //         <li>1</li>
    //     </ul>
    // );
    // const element = React.createElement('h1', { class: 'gratting' }, 'Hello World2!', page1);
    // return element;

    return utils.re_ul([1, 2, 3]);
});