#!/bin/bash

set -eux
cd $(dirname $0)/..

cd ./hack
helmfile -l app=$1 sync
