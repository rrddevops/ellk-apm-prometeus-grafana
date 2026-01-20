FROM docker.elastic.co/apm/apm-server-oss:7.13.0

USER root
COPY apm-server.yml /usr/share/apm-server/apm-server.yml
RUN chmod 644 /usr/share/apm-server/apm-server.yml

USER apm-server
