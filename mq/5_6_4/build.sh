#!/bin/bash

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# 业务变量
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
VRMF=9.2.0.0
EXPORTER_VERSION=5.6.4
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# 基础参数
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
BASE_BUILD_PROGRESS=auto

function exporter() {
  OUT_IMAGE="ibmmq-exporter:${EXPORTER_VERSION}"

  echo -e ">>> Build information"
  echo -e "  >>> BASE_BUILD_PROGRESS=${BASE_BUILD_PROGRESS}"
  echo -e ">>> Starting to build the image (${OUT_IMAGE})\n"

  docker build \
    -f Dockerfile.exporter \
    --build-arg VRMF=${VRMF} \
    --progress=${BASE_BUILD_PROGRESS} \
    -t ${OUT_IMAGE} .
}

function client() {
  OUT_IMAGE="ibmmq-client:${VRMF}"

  echo -e ">>> Build information"
  echo -e "  >>> BASE_BUILD_PROGRESS=${BASE_BUILD_PROGRESS}"
  echo -e ">>> Starting to build the image (${OUT_IMAGE})\n"

  docker build \
    -f Dockerfile.client \
    --build-arg VRMF=${VRMF} \
    --progress=${BASE_BUILD_PROGRESS} \
    -t ${OUT_IMAGE} .
}

action=$(echo "$1" | tr '[:upper:]' '[:lower:]')

case $action in
    exporter)
        exporter
        ;;
    client)
        client
        ;;
    *)
        echo "error：no support param '$1'"
        echo "supper param：exporter, client"
        exit 1
        ;;
esac