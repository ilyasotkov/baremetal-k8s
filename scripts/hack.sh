#!/bin/bash

set -eux
cd $(dirname $0)/..

cd ./hack

if [ $1 == all ]; then
    helmfile -q sync --concurrency=1
else
    helmfile -q -l app=$1 sync --concurrency=1
fi
