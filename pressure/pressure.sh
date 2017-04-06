#!/bin/bash
rm -f pressure.log
ulimit -n 2048
for timelimit in 1 10 30 60 ; do
  for concurrency in 1 10 50 100 500 1000 ; do
    while lsof -i TCP:3000 &>/dev/null ; do sleep 1 ; done
    echo "bin/pressure botkit -t $timelimit -c $concurrency"
    bin/pressure botkit -t $timelimit -c $concurrency
    sleep 1
    while lsof -i TCP:3000 &>/dev/null ; do sleep 1 ; done
    echo "bin/pressure hedwig -t $timelimit -c $concurrency"
    bin/pressure hedwig -t $timelimit -c $concurrency
    sleep 1
  done
done
