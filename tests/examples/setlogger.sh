#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.."

source ../src/brashlib

LOG_LEVEL=7

SetLogger

# echo a random number called with this script so we can find the other output
echo $1

Info 'msg1'
Notice 'msg2'
Warning 'msg3'
Error 'msg4'
Critical 'msg5'
Alert 'msg6'

echo 'stdout'
echo 'stderr' >&2

exit $error
