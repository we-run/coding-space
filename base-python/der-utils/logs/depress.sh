#!/bin/bash
ls  ./*.gz  > install_packge_name.log
for i in `cat install_packge_name.log`  
        do   
                gunzip $i 
        done 
