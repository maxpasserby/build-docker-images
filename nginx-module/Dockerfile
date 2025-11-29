ARG BASE_IMAGE=alpine:latest
FROM ${BASE_IMAGE} AS builder

ARG APK_SOURCE=latest
ARG NGINX_VERSION

RUN mkdir -p /usr/lib/nginx/modules 

RUN if [ -n "$APK_SOURCE" ]; then \
           echo "Using custom APK mirror: $APK_SOURCE"; \
           sed -i "s/dl-cdn.alpinelinux.org/${APK_SOURCE}/g" /etc/apk/repositories; \
       else \
           echo "Using default APK mirror"; \
       fi 

RUN apk add --no-cache \
     build-base \
     pcre-dev \
     zlib-dev \
     openssl-dev \
     linux-headers \
     git \
     wget

# 编译 Nginx（启用 VTS\STS 模块）
RUN wget -O nginx-${NGINX_VERSION}.tar.gz https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
    && tar -zxvf nginx-${NGINX_VERSION}.tar.gz \
    && git clone https://github.com/vozlt/nginx-module-vts.git /nginx-module-vts \
    && git clone https://github.com/vozlt/nginx-module-stream-sts.git /nginx-module-stream-sts \
    && git clone https://github.com/vozlt/nginx-module-sts.git /nginx-module-sts


RUN cd /nginx-${NGINX_VERSION} \
  && ./configure \
      --prefix=/etc/nginx \
      --sbin-path=/usr/sbin/nginx \
      --modules-path=/usr/lib/nginx/modules \
      --conf-path=/etc/nginx/nginx.conf \
      --error-log-path=/var/log/nginx/error.log \
      --http-log-path=/var/log/nginx/access.log \
      --pid-path=/var/run/nginx.pid \
      --lock-path=/var/run/nginx.lock \
      --http-client-body-temp-path=/var/cache/nginx/client_temp \
      --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
      --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
      --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
      --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
      --user=nginx \
      --group=nginx \
      --with-stream \
      --with-threads \
      --with-file-aio \
      --with-http_ssl_module \
      --with-http_v2_module \
      --with-http_realip_module \
      --with-http_gzip_static_module \
      --with-http_stub_status_module \
      --add-module=/nginx-module-vts  \
      --add-module=/nginx-module-stream-sts  \
      --add-module=/nginx-module-sts  \
  && make -j$(nproc)  \
  && make install


# 创建运行时镜像
FROM ${BASE_IMAGE}

ARG APK_SOURCE

RUN if [ -n "$APK_SOURCE" ]; then \
        echo "Using custom APK mirror: $APK_SOURCE"; \
        sed -i "s/dl-cdn.alpinelinux.org/${APK_SOURCE}/g" /etc/apk/repositories; \
    else \
        echo "Using default APK mirror"; \
    fi

# 安装运行时依赖
RUN apk add --no-cache \
      pcre \
      zlib \
      openssl \
      tzdata \
      curl

RUN addgroup -S nginx \
    && adduser -S -G nginx nginx \
    && mkdir -p /var/cache/nginx  \
    && chown -R nginx:nginx /var/cache/nginx

# 从构建阶段复制文件
COPY --from=builder /etc/nginx /etc/nginx
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
COPY --from=builder /usr/lib/nginx/modules /usr/lib/nginx/modules

# 创建日志目录
RUN mkdir -p /var/log/nginx  \
    && touch /var/log/nginx/access.log /var/log/nginx/error.log  \
    && chown -R nginx:nginx /var/log/nginx

# 复制默认配置文件
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露端口（HTTP + VTS 监控端口）
EXPOSE 80 443 9913

# 启动命令
CMD ["nginx", "-g", "daemon off;"]