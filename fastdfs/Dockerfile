FROM alpine:3.16

# 注意
#    v6.0.9 依赖libfastcommon和libserverframe, v6.0.8及以下依赖libevent和libfastcommon两个库，其中libfastcommon是 FastDFS 官方提供的
#    v6.0.9 适配fastdfs-nginx-module-1.23，v6.0.8及以下是fastdfs-nginx-module-1.22

# 0.安装包位置，fdfs的基本目录和存储目录
ARG INSTALL_PATH=/tmp/install

ARG FASTDFS_VERSION
ARG LIBFASTCOMMON_VERSION=V1.0.77
ARG LIBSERVERFRAME_VERSION=V1.2.7
ARG FASTDFS_NGINX_MODULE_VERSION=V1.24
ARG NGINX_VERSION=1.27.4

# 0.change the system source for installing libs
RUN echo "http://mirrors.aliyun.com/alpine/v3.16/main" > /etc/apk/repositories 
RUN echo "http://mirrors.aliyun.com/alpine/v3.16/community" >> /etc/apk/repositories

# 1.复制安装包
ADD repository ${INSTALL_PATH}

# 2.环境安装
# - 创建fdfs的存储目录
# - 安装依赖
# - 安装libfastcommon
# - 安装fastdfs
# - 安装nginx,设置nginx和fastdfs联合环境
#Run yum -y install -y gcc gcc-c++ libevent libevent-devel make automake autoconf libtool perl pcre pcre-devel zlib zlib-devel openssl openssl-devel zip unzip net-tools wget vim lsof  \
RUN  apk update  \
  && apk add --no-cache --virtual .build-deps autoconf gcc libc-dev make pcre-dev zlib-dev linux-headers gnupg libxslt-dev gd-dev geoip-dev \
  && apk add --no-cache --virtual .tool-deps bash net-tools curl unzip \
      \
  &&  cd ${INSTALL_PATH}  \
  &&  unzip libfastcommon-${LIBFASTCOMMON_VERSION}.zip \
  &&  unzip libserverframe-${LIBSERVERFRAME_VERSION}.zip \
  &&  unzip fastdfs-${FASTDFS_VERSION}.zip \
  &&  unzip fastdfs-nginx-module-${FASTDFS_NGINX_MODULE_VERSION}.zip \
  &&  tar -zxf nginx-${NGINX_VERSION}.tar.gz \
      \  
  &&  cd ${INSTALL_PATH}/libfastcommon-${LIBFASTCOMMON_VERSION}/ \
  &&  ./make.sh \
  &&  ./make.sh install \
  &&  cd ${INSTALL_PATH}/libserverframe-${LIBSERVERFRAME_VERSION}/ \
  &&  ./make.sh \
  &&  ./make.sh install \
  &&  cd ${INSTALL_PATH}/fastdfs-${FASTDFS_VERSION}/ \
  &&  ./make.sh \
  &&  ./make.sh install \
      \  
  &&  cd ${INSTALL_PATH}/nginx-${NGINX_VERSION}/ \
  &&  ./configure --prefix=/usr/local/nginx \
      --pid-path=/var/run/nginx/nginx.pid  \
      --with-http_stub_status_module \ 
      --with-http_gzip_static_module \ 
      --with-http_realip_module \ 
      --with-http_sub_module \ 
      --with-stream=dynamic \
      --add-module=${INSTALL_PATH}/fastdfs-nginx-module-${FASTDFS_NGINX_MODULE_VERSION}/src/ \
  &&  make \
  &&  make install \
      \  
  &&  mkdir -p /usr/local/nginx/conf.d/ \
  &&  cp ${INSTALL_PATH}/conf/*.* /etc/fdfs/ \
  &&  cp ${INSTALL_PATH}/nginx_conf/nginx.conf /usr/local/nginx/conf/ \
  &&  cp ${INSTALL_PATH}/nginx_conf.d/*.conf /usr/local/nginx/conf.d/ \
  &&  cp ${INSTALL_PATH}/entrypoint.sh / \
      \
  &&  rm -rf ${INSTALL_PATH}/* \
  &&  apk del .build-deps

EXPOSE 22122 23000 9088

WORKDIR /

# 镜像启动
ENTRYPOINT ["/bin/bash","/entrypoint.sh"]
