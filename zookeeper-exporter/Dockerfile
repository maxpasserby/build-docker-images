ARG BASE_IMAGE=alpine:latest

FROM docker.m.daocloud.io/golang:1.10 AS builder
WORKDIR /go/src/github.com/carlpett/zookeeper_exporter/
COPY zookeeper_exporter/ .
RUN make build


FROM ${BASE_IMAGE}

ARG APK_SOURCE

RUN if [ -n "$APK_SOURCE" ]; then \
        echo "Using custom APK mirror: $APK_SOURCE"; \
        sed -i "s/dl-cdn.alpinelinux.org/${APK_SOURCE}/g" /etc/apk/repositories; \
    else \
        echo "Using default APK mirror"; \
    fi

RUN apk update \
    && apk add --no-cache ca-certificates


USER 1000

COPY --from=builder /go/src/github.com/carlpett/zookeeper_exporter/zookeeper_exporter /zookeeper_exporter

EXPOSE 9141

ENTRYPOINT ["/zookeeper_exporter"]