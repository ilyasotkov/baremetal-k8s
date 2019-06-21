#!/bin/bash

set -eux
cd $(dirname $0)/..

kubectl apply -f ./hack/raw/tiller-sa.yaml
kubectl apply -f ./hack/raw/admin-user.yaml
helm init --service-account tiller --upgrade --history-max=2 --wait
