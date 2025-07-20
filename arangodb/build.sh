#!/bin/bash

function verify() {
  if [ ! -f "VERSION" ]; then
    echo -e ">>> Error: VERSION file does not exists"
    exit 1
  fi

  if command -v docker &> /dev/null; then
      echo -e ">>> Docker is already installed ($(docker -v 2>&1)) "
  else
      echo -e ">>> Error: Please install Docker first"
      exit 1
  fi
}

function build() {
  VERSION=$(<VERSION)
  IMAGE="arangodb:${VERSION}"

  echo -e ">>> Starting to build the image (${IMAGE})"
  docker build \
    --build-arg ARANGO_VERSION=${VERSION} \
    -t ${IMAGE} .
}

function main() {
  verify
  build
}

main $@