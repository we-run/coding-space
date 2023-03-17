#!/bin/sh
ES_VER=$1
cd ..
if [ ! -f './elasticsearch-'$ES_VER'.tar.gz' ]; then
  curl --progress-bar -o ./elasticsearch-"$ES_VER".tar.gz https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-"$ES_VER"-linux-x86_64.tar.gz
fi

if [ ! -f "./kibana-"$ES_VER".tar.gz" ]; then
  curl --progress-bar -o ./kibana-"$ES_VER".tar.gz https://artifacts.elastic.co/downloads/kibana/kibana-"$ES_VER"-linux-x86_64.tar.gz
fi


if [ ! -f "./metricbeat-"$ES_VER".tar.gz" ]; then
  echo 'download beats ... '
  #curl --progress-bar -o ./metricbeat-"$ES_VER".tar.gz https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-"$ES_VER"-linux-x86_64.tar.gz
  #curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.1.3-linux-x86_64.tar.gz
  
fi
