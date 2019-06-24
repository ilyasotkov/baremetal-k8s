#!/bin/bash

set -eux
cd $(dirname $0)/..

cd ./hack
flags="--quiet"

if [ $1 == all ]; then
    helmfile $flags --file helmfile.yaml sync --concurrency=1
else
    helmfile $flags --file helmfile.yaml --selector $1 sync --concurrency=1
fi
