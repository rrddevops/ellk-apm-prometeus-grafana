FROM docker.elastic.co/beats/heartbeat:7.13.0

USER root
COPY heartbeat.yml /usr/share/heartbeat/heartbeat.yml
RUN chmod 644 /usr/share/heartbeat/heartbeat.yml

USER heartbeat
