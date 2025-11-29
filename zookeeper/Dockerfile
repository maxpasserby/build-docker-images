FROM debian:bookworm-slim

ARG BASE_SOURCE=latest
ARG APP_VERSION=3.4.8

ENV ZOO_CONF_DIR=/conf \
    ZOO_DATA_DIR=/data \
    ZOO_DATA_LOG_DIR=/datalog \
    ZOO_LOG_DIR=/logs \
    ZOO_TICK_TIME=2000 \
    ZOO_INIT_LIMIT=5 \
    ZOO_SYNC_LIMIT=2 \
    ZOO_AUTOPURGE_PURGEINTERVAL=0 \
    ZOO_AUTOPURGE_SNAPRETAINCOUNT=3 \
    ZOO_MAX_CLIENT_CNXNS=60 \
    ZOO_STANDALONE_ENABLED=true \
    ZOO_ADMINSERVER_ENABLED=true 

RUN sed -i "s|deb.debian.org|${BASE_SOURCE}|g" /etc/apt/sources.list.d/*.sources \ 
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        openjdk-17-jre \
        wget \
    && rm -rf /var/lib/apt/lists/*

# Add a user with an explicit UID/GID and create necessary directories
RUN set -eux \
    && groupadd -g 1000 zookeeper \
    && useradd -u 1000 -g 1000 zookeeper \
    && mkdir -p "$ZOO_DATA_LOG_DIR" "$ZOO_DATA_DIR" "$ZOO_CONF_DIR" "$ZOO_LOG_DIR" 
RUN chown 1000:1000 "$ZOO_DATA_LOG_DIR" "$ZOO_DATA_DIR" "$ZOO_CONF_DIR" "$ZOO_LOG_DIR"

COPY zookeeper-${APP_VERSION}.tar.gz /
COPY docker-entrypoint.sh /

RUN set -eux \
    # wget https://archive.apache.org/dist/zookeeper/zookeeper-${APP_VERSION}/zookeeper-${APP_VERSION}.tar.gz; \
    && tar -zxf "zookeeper-${APP_VERSION}.tar.gz" \
    && mv "/zookeeper-${APP_VERSION}/conf/"* "$ZOO_CONF_DIR" \
    && rm -rf "/zookeeper-${APP_VERSION}.tar.gz" \
    && chown -R zookeeper:zookeeper "/zookeeper-${APP_VERSION}" \
    && chown -R zookeeper:zookeeper "$ZOO_CONF_DIR" \
    && chmod a+rx /docker-entrypoint.sh


WORKDIR /zookeeper-${APP_VERSION}
VOLUME ["$ZOO_DATA_DIR", "$ZOO_DATA_LOG_DIR", "$ZOO_LOG_DIR"]

EXPOSE 2181 2888 3888 8080

ENV PATH=$PATH:/zookeeper-${APP_VERSION}/bin \
    ZOOCFGDIR=$ZOO_CONF_DIR


ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["zkServer.sh", "start-foreground"]

