FROM docker.elastic.co/beats/metricbeat:7.13.0

USER root
COPY metricbeat.yml /usr/share/metricbeat/metricbeat.yml
RUN chmod 644 /usr/share/metricbeat/metricbeat.yml

USER metricbeat
