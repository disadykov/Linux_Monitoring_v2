#!/bin/bash

#nginx
sudo cp nginx.conf /etc/nginx/nginx.conf
sudo systemctl restart nginx.service

#prometheus
sudo cp prometheus.yml /etc/prometheus/prometheus.yml
sudo chown -R prometheus:prometheus /etc/prometheus/prometheus.yml
sudo systemctl restart prometheus.service


