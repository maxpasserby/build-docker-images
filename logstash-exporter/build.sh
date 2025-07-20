#!/bin/bash

VERSION=v1.9.0
IMAGE="kuskoman/logstash-exporter:${VERSION}"

function verify() {
  if command -v docker &> /dev/null; then
      echo -e ">>> Docker is already installed ($(docker -v 2>&1)) "
  else
      echo -e ">>> Please install Docker first"
      exit 1
  fi
}


function build() {
  docker build -t ${IMAGE} .
}

function main() {
  verify
  build $@
}

main $@