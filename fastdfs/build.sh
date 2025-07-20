#!/bin/bash

FASTDFS_VERSION=""
LIBFASTCOMMON_VERSION=""
LIBSERVERFRAME_VERSION=""
FASTDFS_NGINX_MODULE_VERSION=""
NGINX_VERSION=""

function verify() {
  if [ ! -f "VERSION" ]; then
    echo -e ">>> Error: VERSION file is not exit"
    exit 1
  fi

  if command -v docker &> /dev/null; then
      echo -e ">>> Docker is already installed ($(docker -v 2>&1)) "
  else
      echo -e ">>> Error: Please install Docker first"
      exit 1
  fi

  if command -v wget &> /dev/null; then
      echo -e ">>> wget is already installed "
  else
      echo -e ">>> Error: Please install wget first"
      exit 1
  fi
}

function prepare() {

  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ -z "$line" || "$line" =~ ^# ]]; then
        continue
    fi
    
    software=$(echo "$line" | cut -d'=' -f1 | tr -d '[:space:]')
    version=$(echo "$line" | cut -d'=' -f2 | tr -d '[:space:]')

    if [ -z "$software" ] || [ -z "$version" ]; then
        continue
    fi

    case "$software" in
        "fastdfs")
            FASTDFS_VERSION=${version}
            
            echo -e ">>> Downloading $software, version: $version"
            download_url="https://github.com/happyfish100/fastdfs/archive/refs/tags/V${version}.zip"
            wget -c "$download_url" -O "./repository/${software}-${version}.zip"
            
            if [ $? -eq 0 ]; then
                echo -e ">>> Successfully downloaded: ${software}-${version}.zip"
            else
                echo -e ">>> Failed downloaded: ${software}-${version}.zip, Exiting script"
                exit 1
            fi
            ;;
        "libfastcommon")
            LIBFASTCOMMON_VERSION=${version}
            # download_url="https://github.com/happyfish100/libfastcommon/archive/refs/tags/${version}.zip"
            ;;
        "fastdfs-nginx-module")
            FASTDFS_NGINX_MODULE_VERSION=${version}
            # download_url="https://github.com/happyfish100/fastdfs-nginx-module/archive/refs/tags/${version}.zip"
            ;;
        "libserverframe")
            LIBSERVERFRAME_VERSION=${version}
            # download_url="https://github.com/happyfish100/libserverframe/archive/refs/tags/${version}.zip"
            ;;
        "nginx")
            NGINX_VERSION=${version}
            # download_url="https://github.com/nginx/nginx/archive/refs/tags/release-${version}.zip"
            ;;
        *)
    esac
  done < VERSION
}

function build() {
  IMAGE="fastdfs:${FASTDFS_VERSION}"
  
  echo -e ">>> Component version"
  echo -e "  >>> FASTDFS_VERSION=${FASTDFS_VERSION}"
  echo -e "  >>> FASTDFS_NGINX_MODULE_VERSION=${FASTDFFASTDFS_NGINX_MODULE_VERSION_VERSION}"
  echo -e "  >>> LIBFASTCOMMON_VERSION=${LIBFASTCOMMON_VERSION}"
  echo -e "  >>> LIBSERVERFRAME_VERSION=${LIBSERVERFRAME_VERSION}"
  echo -e "  >>> NGINX_VERSION=${NGINX_VERSION}"
  echo -e ">>> Starting to build the image (${IMAGE})"
  docker build \
    --build-arg FASTDFS_VERSION=${FASTDFS_VERSION} \
    --build-arg FASTDFS_NGINX_MODULE_VERSION=${FASTDFS_NGINX_MODULE_VERSION} \
    --build-arg LIBFASTCOMMON_VERSION=${LIBFASTCOMMON_VERSION} \
    --build-arg LIBSERVERFRAME_VERSION=${LIBSERVERFRAME_VERSION} \
    --build-arg NGINX_VERSION=${NGINX_VERSION} \
    -t ${IMAGE} .
}

function main() {
  verify
  prepare
  build
}

main $@