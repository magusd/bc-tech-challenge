#!/bin/bash

echo ":::Step 1: Login to Docker Registry:::"
CR_USER=${CR_USER:-"unclelobs"}
CR_HOST=${CR_HOST:-"https://index.docker.io/v1/"}
CR_PASS=${CR_PASS:-""}

if [ -z "$CR_PASS" ]; then
    echo "Error: CR_PASS is not set. Please set the CR_PASS environment"
    exit 1
fi

docker login $CR_HOST \
    --username $CR_USER \
    --password $CR_PASS

echo ":::Step 2: Build the container:::"
CALVER=$(date +"%Y.%-m.%-d-%-H.%-M")
export DOCKER_TAG=$CALVER
export DOCKER_IMAGE="unclelobs/bluecore-counter"
docker compose build api

echo ":::Step 3: Push the container:::"
docker compose push api

echo ":::Step 4: Deploy the container to Kubernetes:::"
NAMESPACE=${NAMESPACE:-"bluecore-counter"}

echo "Using namespace: $NAMESPACE"
kubectl get namespace "$NAMESPACE" || kubectl create namespace "$NAMESPACE"

echo "Ensuring the Docker registry secret exists in the namespace"
kubectl get secret bluecore-regcred -n "$NAMESPACE" || \
    kubectl create secret docker-registry bluecore-regcred \
        --docker-username="$CR_USER" \
        --docker-password="$CR_PASS" \
        --docker-server="$CR_HOST"

echo "Ensuring we have the redis password"
export REDIS_PASSWORD=$(kubectl get secret --namespace "bluecore-counter" bluecore-counter-redis -o jsonpath="{.data.redis-password}" | base64 -d || echo "")

echo "REDIS_PASSWORD: $REDIS_PASSWORD"

helm dependencies build ./infra/helm
helm upgrade --install \
    --wait --timeout 10m \
    --namespace "$NAMESPACE" \
    --set image.tag=$DOCKER_TAG \
    --set image.repository=$DOCKER_IMAGE \
    --set imagePullSecrets[0].name=bluecore-regcred \
    --set redis.auth.password=$REDIS_PASSWORD \
    -f ./infra/env/dev.yaml \
    bluecore-counter \
    ./infra/helm