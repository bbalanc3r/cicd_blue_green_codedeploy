#!/bin/bash
set -e
CONTAINER_NAME="cmtr-ac8bmr88-north-pole"
if docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
    docker stop $CONTAINER_NAME || true
    docker rm $CONTAINER_NAME || true
fi