#!/bin/bash

#install
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install prometheus -y
sudo snap install grafana
sudo apt-get install stress -y


echo "For a correct connection, configure port forwarding on the virtual machine in VirtualBox (9090 and 3000)"
echo "Prometheus: http://localhost:9090"
echo "Grafana: http://localhost:3000"

