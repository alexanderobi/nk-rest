#!/bin/bash

# Exit on any error
set -e

docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS
docker push alexebube/nk-rest-api
sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube
kubectl patch deployment nk-rest -p '{"spec":{"template":{"spec":{"containers":[{"name":"nk-rest","image":"alexebube/nk-rest-api:latest"}]}}}}'