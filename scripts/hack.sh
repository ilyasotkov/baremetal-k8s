#!/bin/bash

set -eux
cd $(dirname $0)/..

helm upgrade --install --force \
nginx-app ./hack/helm/nginx-app

helm upgrade --install --force \
metallb stable/metallb \
--values ./hack/helm/metallb/values.yaml

kubectl apply -f ./hack/raw/metallb-demo-app.yaml

kubectl apply -f ./hack/raw/monitoring-namespace.yaml
helm upgrade --install --force --namespace monitoring \
prometheus-operator stable/prometheus-operator --version 5.12.3 \
--values ./hack/helm/prometheus-operator/values.yaml
