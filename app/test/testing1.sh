#!/bin/sh

if [ $# -lt 2 ]; then
  echo "Usage: $0 <APP-IP> <APP-PORT>"
  exit 1
fi

APP_IP=$1
APP_PORT=$2

curl "${APP_IP}:${APP_PORT}/drop/dahab"
# read each line from test file
while read line; do
  curl_cmd=`echo $line | awk -F"->" '{print $1}'`
  expected_res=`echo $line | awk -F"->" '{print $2}'`
  result= `eval $curl_cmd``

  # check if the result is expected
  if echo "$result" | grep -q "$expected_res"; then
    echo "Test passed."
  else
    echo "Test failed. Result: $result"
    exit 1
  fi
done < test
