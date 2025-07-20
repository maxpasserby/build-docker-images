FROM alpine:3.16
MAINTAINER Frank Celler <info@arangodb.com>

ARG ARANGO_VERSION

# see
#   https://www.arangodb.com/docs/3.11/programs-arangod-server.html#managing-endpoints
#   https://www.arangodb.com/docs/3.11/programs-arangod-log.html

ARG GID=1000
ARG UID=1000

RUN echo "bes:x:$GID:" >> /etc/group && \
    echo "bes:x:$UID:$GID::/home/bes:/bin/sh" >> /etc/passwd && \
    mkdir -p /home/bes && \
    chown bes:bes /home/bes && \
    chmod 755 /home/bes && \
    echo "http://mirrors.aliyun.com/alpine/v3.16/main" > /etc/apk/repositories && \
    echo "http://mirrors.aliyun.com/alpine/v3.16/community" >> /etc/apk/repositories && \ 
    apk add --no-cache gnupg pwgen binutils numactl numactl-tools nodejs yarn && \
    yarn global add foxx-cli@2.1.1 && \
    apk del yarn && \
    gpg --batch --keyserver keys.openpgp.org --recv-keys CD8CB0F1E0AD5B52E93F41E7EA93F5E56E751E9B && \
    mkdir /docker-entrypoint-initdb.d && \
    cd /tmp                                && \
    arch="$(apk --print-arch)"             && \
    case "$arch" in                           \
        x86_64)  dpkgArch='amd64'          ;; \
        aarch64) dpkgArch='arm64'          ;; \
        *) echo >&2 "unsupported: $arch" && exit 1 ;; \
    esac                                   && \
    ARANGO_URL="https://download.arangodb.com/arangodb311/DEBIAN/$dpkgArch" && \
    ARANGO_PACKAGE="arangodb3_${ARANGO_VERSION}-1_${dpkgArch}.deb" && \
    ARANGO_PACKAGE_URL="${ARANGO_URL}/${ARANGO_PACKAGE}" && \
    ARANGO_SIGNATURE_URL="${ARANGO_PACKAGE_URL}.asc" && \
    wget ${ARANGO_SIGNATURE_URL}           && \
    wget ${ARANGO_PACKAGE_URL}             && \
    gpg --verify ${ARANGO_PACKAGE}.asc     && \
    ar x ${ARANGO_PACKAGE} data.tar.gz     && \
    tar -C / -x -z -f data.tar.gz          && \
    sed -ri \
        -e 's!127\.0\.0\.1!0.0.0.0!g' \
        -e 's!^(file\s*=\s*).*!\1 -!' \
        -e 's!^\s*uid\s*=.*!!' \
        /etc/arangodb3/arangod.conf        && \
    mkdir -p /var/log/arangodb3 && \
    chown -R bes:bes /var/log/arangodb3 /var/lib/arangodb3 /var/lib/arangodb3-apps /usr/share/arangodb3 /etc/arangodb3 /docker-entrypoint-initdb.d && \
    chown -R bes:bes /usr/bin/arango* && \
    chmod -R 775 /var/lib/arangodb3 /var/lib/arangodb3-apps && \
    rm -f /usr/bin/foxx && \
    rm -f ${ARANGO_PACKAGE}* data.tar.gz && \
    apk del gnupg 

# Note that Openshift runs containers by default with a random UID and GID 0.
# We need that the database and apps directory are writable for this config.

ENV GLIBCXX_FORCE_NEW=1

# Adjust TZ by default since tzdata package isn't present (BTS-913)
RUN echo "UTC" > /etc/timezone

# retain the database directory and the Foxx Application directory
VOLUME ["/var/lib/arangodb3", "/var/lib/arangodb3-apps"]


COPY docker-entrypoint.sh /entrypoint.sh
COPY docker-foxx.sh /usr/bin/foxx

RUN chmod +x /entrypoint.sh && \
    chmod +x /usr/bin/foxx && \
    chown -R bes:bes /entrypoint.sh /usr/bin/foxx 

USER $UID

ENTRYPOINT ["/entrypoint.sh"]

# standard port
EXPOSE 8529
CMD ["arangod"]