#!/bin/bash -eu

ulimit -n 2048
rm -f pressure.log

impls=()
impls+=("coffeescript_nodejs")
impls+=("crystal_crystal")
impls+=("elixir_cowboy")
impls+=("groovy_vertx")
impls+=("jruby_vertx")
impls+=("opal_nodejs")
impls+=("ruby_puma")
impls+=("ruby_unicorn")
# for impl in "${impls[@]}" ; do
#   cd "../$impl" && make clean build
# done
for impl in "${impls[@]}" ; do
  for concurrency in 5 50 500 ; do
    echo "bin/pressure $impl -t 15 -c $concurrency"
    bin/pressure "$impl" -t 15 -c "$concurrency"
  done
done
