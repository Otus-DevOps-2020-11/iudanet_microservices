FROM prom/blackbox-exporter:v0.18.0
COPY blackbox_config.yml build_info.txt  /etc/blackbox_exporter/
CMD [ "--config.file=/etc/blackbox_exporter/blackbox_config.yml" ]
