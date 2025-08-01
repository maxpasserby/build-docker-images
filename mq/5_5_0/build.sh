#!/bin/bash

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# 业务变量
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
VRMF=9.2.0.0
EXPORTER_VERSION=5.5.0
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
# 基础参数
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #
BASE_BUILD_IMAGE=quay.io/goland:1.19
BASE_RUN_IMAGE=debian:bookworm-slim
BASE_SOURCE=mirrors.tuna.tsinghua.edu.cn
# 控制构建日志的输出格式
#   auto	自动选择（默认值）
#   tty	交互式终端格式，显示动态更新的单行进度条（需终端支持 ANSI 控制）
#   plain	原始文本输出，逐行打印完整日志（无颜色/进度条）
#   json	输出 JSON 格式的构建日志（每行一个 JSON 对象）
BASE_BUILD_PROGRESS=auto

function exporter() {
  OUT_IMAGE="ibmmq-exporter:${EXPORTER_VERSION}"

  echo -e ">>> Build information"
  echo -e "  >>> BASE_BUILD_IMAGE=${BASE_BUILD_IMAGE}"
  echo -e "  >>> BASE_RUN_IMAGE=${BASE_RUN_IMAGE}"
  echo -e "  >>> BASE_SOURCE=${BASE_SOURCE}"
  echo -e "  >>> BASE_BUILD_PROGRESS=${BASE_BUILD_PROGRESS}"
  echo -e ">>> Starting to build the image (${OUT_IMAGE})\n"

  docker build \
    -f Dockerfile.exporter \
    --build-arg BASE_BUILD_IMAGE=${BASE_BUILD_IMAGE} \
    --build-arg BASE_RUN_IMAGE=${BASE_RUN_IMAGE} \
    --build-arg BASE_SOURCE=${BASE_SOURCE} \
    --build-arg VRMF=${VRMF} \
    --progress=${BASE_BUILD_PROGRESS} \
    -t ${OUT_IMAGE} .
}

function client() {
  OUT_IMAGE="ibmmq-client:${VRMF}"

  echo -e ">>> Build information"
  echo -e "  >>> BASE_BUILD_IMAGE=${BASE_BUILD_IMAGE}"
  
  echo -e "  >>> BASE_SOURCE=${BASE_SOURCE}"
  echo -e "  >>> BASE_BUILD_PROGRESS=${BASE_BUILD_PROGRESS}"
  echo -e ">>> Starting to build the image (${OUT_IMAGE})\n"

  docker build \
    -f Dockerfile.client \
    --build-arg BASE_BUILD_IMAGE=${BASE_BUILD_IMAGE} \
    --build-arg BASE_SOURCE=${BASE_SOURCE} \
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