#!/bin/bash

set -eux
cd $(dirname $0)/..

cd ./hack
helmfile sync
