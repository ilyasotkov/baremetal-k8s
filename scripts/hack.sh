#!/bin/bash

set -eux
cd $(dirname $0)/..

cd ./hack

if [ $1 == all ]; then
    helmfile --quiet --file helmfile.yaml sync --concurrency=1
else
    helmfile --quiet --file helmfile.yaml --selector app=$1 sync --concurrency=1
fi
