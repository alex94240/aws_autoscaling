#!/bin/bash

sudo yum update
sudo yum -y install docker

sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo systemctl start docker.service
sudo docker run -d --rm -p 1080:1080 mockserver/mockserver