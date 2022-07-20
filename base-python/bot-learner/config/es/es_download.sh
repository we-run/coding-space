#!/bin/sh

cd $HOME
if [ ! -f './elasticsearch-'$ES_VER'.tar.gz' ]; then
  curl --progress-bar -o ./elasticsearch-"$ES_VER".tar.gz https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-"$ES_VER"-linux-x86_64.tar.gz
fi


if [ ! -f "./kibana-"$ES_VER".tar.gz" ]; then
  curl --progress-bar -o ./kibana-"$ES_VER".tar.gz https://artifacts.elastic.co/downloads/kibana/kibana-"$ES_VER"-linux-x86_64.tar.gz
fi
