#!/bin/bash

set -eux
cd $(dirname $0)/..

kubectl apply -f ./hack/raw/admin-user.yaml
kubectl apply -f ./hack/raw/tiller-sa.yaml

helm init --service-account tiller --wait --history-max 5 --upgrade --replicas 3
