#!/bin/sh


function is_my_macos(){
    if [[ `uname` -eq 'Darwin' ]]; then 
        return 1
    else 
        return 0
    fi 
}
function is_my_linux(){
    if [[ `uname` -eq 'Linux' ]]; then 
        return 1
    else 
        return 0
    fi 
}
