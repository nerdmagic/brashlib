#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.."

source ../src/brashlib

LOG_LEVEL=7

Info 'msg1'
Notice 'msg2'
Warning 'msg3'
Error 'msg4'
Critical 'msg5'
Alert 'msg6'

exit $error
