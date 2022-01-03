#!/bin/bash
res=$(ps -e -o command | grep -e 'jenkins-agent' | grep 'remoting')
# echo $res
if [[ -n $res ]]; then
  echo "jenkins agent is running"
  exit 0
else
  echo "jenkins agent not running"
  exit 1
fi
