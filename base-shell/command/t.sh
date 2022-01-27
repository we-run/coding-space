#!/bin/sh

### command 是shell内建命令，可以无视与shell同名的函数脚本，直接对原生shell进行执行

function ls(){
    echo "just do"
}

echo " -- none --"
ls 


echo " --- ignore --"
command ls