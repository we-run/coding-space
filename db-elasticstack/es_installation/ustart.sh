#!/bin/sh



su - $1 -- <<EOF

TO_KILL=$(ps aux | awk '$(NF-1)$NF ~ /bootstrap.Elasticsearch/ {print $2}')
# TO_KILL=$(ps aux | grep -E -e 'org.elasticsearch.bootstrap.Elasticsearch' | awk '$11 ~ /java$/ {print $2}')
if [[ -n $TO_KILL ]];then
    echo "Kill old es ..."$TO_KILL
    kill -9 $TO_KILL
fi

EOF

