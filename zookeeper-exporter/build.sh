#!/bin/bash
set -e

ARCH=$(uname -m)
BASE_IMAGE=docker.m.daocloud.io/alpine:3.21
APK_SOURCE=mirrors.tuna.tsinghua.edu.cn

APP_VERSION="v1.1.0"
IMAGE="carlpett/zookeeper_exporter:${APP_VERSION}"

function clone() {
  git clone https://github.com/carlpett/zookeeper_exporter.git

  cd zookeeper_exporter
  git checkout ${APP_VERSION}
  git branch -a
  cd ..
}


function build() {
  echo -e ">>> Build information"
  echo -e "  >>> BASE_IMAGE=${BASE_IMAGE}"
  echo -e "  >>> APK_SOURCE=${APK_SOURCE}"
  echo -e ">>> Starting to build the image (${IMAGE})\n"
  docker build \
    --build-arg BASE_IMAGE=${BASE_IMAGE} \
    --build-arg APK_SOURCE=${APK_SOURCE} \
    -t ${IMAGE} .
}

function save() {
  docker save ${IMAGE} | gzip -9 -> build.local~carlpett~zookeeper-exporter~${APP_VERSION}~${ARCH}.tar.gz
}

function clear() {
  rm -rf zookeeper_exporter
}

function main() {
  clone
  build
  save
  clear
}

main $@
