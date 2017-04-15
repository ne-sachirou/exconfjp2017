#!/bin/bash -eu

function pressure {
  while lsof -i TCP:3000 &>/dev/null ; do sleep 1 ; done
  sleep 3
  echo "bin/pressure botkit -t $1 -c $2"
  bin/pressure botkit -t $1 -c $2
  sleep 3

  while lsof -i TCP:3000 &>/dev/null ; do sleep 1 ; done
  sleep 3
  echo "bin/pressure hedwig -t $1 -c $2"
  bin/pressure botkit -t $1 -c $2
  sleep 3
}

ulimit -n 2048
rm -f pressure.log
pressure 5 1000
echo
echo "node -v"
node -v
echo "elixir -v"
elixir -v
rm -f pressure.log
for timelimit in 1 15 30 ; do
  for concurrency in 1 10 50 100 500 1000 ; do
    pressure $timelimit $concurrency
  done
done
