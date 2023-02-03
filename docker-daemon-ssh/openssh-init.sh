#!/bin/bash
# set -e

# This script will run on openssh-server startup to install Docker client
# and setup env variables allowing to reach DinD container

apk update && apk add docker-cli

echo "SetEnv" \
  "DOCKER_HOST=tcp://docker:2376" \
  "DOCKER_CERT_PATH=/certs/client" \
  "DOCKER_TLS_VERIFY=1" \
  >> /etc/ssh/sshd_config
