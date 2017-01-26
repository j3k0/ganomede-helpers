#!/bin/sh
set -e
./node_modules/.bin/coffeelint -q src tests
./node_modules/.bin/mocha -b --recursive --compilers coffee:coffee-script/register tests | ./node_modules/.bin/bunyan -l 1000
