#!/bin/bash

set -eux
cd $(dirname $0)/..

helm init

helm upgrade --install --force \
metallb stable/metallb \
--values ./hack/metallb/values.yaml

kubectl apply -f ./hack/metallb-demo-app.yaml
