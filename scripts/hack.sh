#!/bin/bash

set -eux
cd $(dirname $0)/..

helm init

kubectl apply -f ./hack/raw/admin-user.yaml

helm upgrade --install --force \
nginx-app ./hack/helm/nginx-app

helm upgrade --install --force \
metallb stable/metallb \
--values ./hack/helm/metallb/values.yaml

kubectl apply -f ./hack/raw/metallb-demo-app.yaml
