FROM alpine:3.21

# 维护者信息
LABEL maintainer="kuskoman"
LABEL org.opencontainers.image.source="https://github.com/kuskoman/logstash-exporter"

ENV LOGSTASH_URL=http://localhost:9600
ENV PORT=9198
ENV HOST=0.0.0.0
ENV LOG_LEVEL=info

COPY logstash-exporter /opt/exporter/logstash-exporter

RUN chmod +x /opt/exporter/logstash-exporter

WORKDIR /opt/exporter

EXPOSE 9198

ENTRYPOINT ["/opt/exporter/logstash-exporter"]