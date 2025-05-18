#!/bin/bash

# 변수 설정
IMAGE_NAME="openvpn-server"
DOCKER_VOLUME="$IMAGE_NAME-volume"
TAG="latest"
DOCKER_USERNAME="agnusdei1207"
DOCKER_IMAGE="$DOCKER_USERNAME/$IMAGE_NAME:$TAG"
DOCKERFILE="docker/$IMAGE_NAME/Dockerfile"

source docker/common/common.sh

