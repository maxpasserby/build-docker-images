#!/bin/bash

BASE_IMAGE=alpine:3.21
NGINX_VERSION=1.28.0
APK_SOURCE=mirrors.tuna.tsinghua.edu.cn

IMAGE="nginx:${NGINX_VERSION}"

function main() {
  echo -e ">>> Build information"
  echo -e "  >>> BASE_IMAGE=${BASE_IMAGE}"
  echo -e "  >>> NGINX_VERSION=${NGINX_VERSION}"
  echo -e "  >>> APK_SOURCE=${APK_SOURCE}"
  echo -e ">>> Starting to build the image (${IMAGE})\n"
  docker build \
    --build-arg BASE_IMAGE=${BASE_IMAGE} \
    --build-arg NGINX_VERSION=${NGINX_VERSION} \
    --build-arg APK_SOURCE=${APK_SOURCE} \
    -t ${IMAGE} .

    
}

main $@