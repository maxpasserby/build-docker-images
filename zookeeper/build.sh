#!/bin/bash

BASE_IMAGE=docker.m.daocloud.io/alpine:3.21
APP_VERSION=3.4.8
BASE_SOURCE=mirrors.tuna.tsinghua.edu.cn
IMAGE="zookeeper:3.4.8"

function main() {
  echo -e ">>> Build information"
  echo -e "  >>> APP_VERSION=${APP_VERSION}"
  echo -e "  >>> BASE_SOURCE=${BASE_SOURCE}"
  echo -e ">>> Starting to build the image (${IMAGE})\n"
  docker build \
    --build-arg APP_VERSION=${APP_VERSION} \
    --build-arg BASE_SOURCE=${BASE_SOURCE} \
    -t ${IMAGE} . 
}

main $@