#!/bin/bash

set -e

# cleanup before run
rm -rf .tls

# Init dirs
mkdir ${PWD}/.tls
mkdir ${PWD}/.tls/ca
mkdir ${PWD}/.tls/client
mkdir ${PWD}/.tls/server

# CA
openssl genrsa -out .tls/ca/key.pem 4096
openssl req -subj "/CN=localhost" -new -x509 -days 365 -key .tls/ca/key.pem -sha256 -out .tls/ca/ca.pem

# Cert
openssl genrsa -out .tls/server/key.pem 4096
openssl req -subj "/CN=localhost" -sha256 -new -key .tls/server/key.pem -out .tls/server/server.csr

echo subjectAltName = DNS:localhost,IP:127.0.0.1 > extfile.cnf
echo extendedKeyUsage = serverAuth >> extfile.cnf

openssl x509 -req -days 365 -sha256 -in .tls/server/server.csr -CA .tls/ca/ca.pem -CAkey .tls/ca/key.pem -CAcreateserial -out .tls/server/cert.pem -extfile extfile.cnf

# Client
openssl genrsa -out .tls/client/key.pem 4096
openssl req -subj '/CN=client' -new -key .tls/client/key.pem -out .tls/client/client.csr

echo extendedKeyUsage = clientAuth > extfile-client.cnf

openssl x509 -req -days 365 -sha256 -in .tls/client/client.csr -CA .tls/ca/ca.pem -CAkey .tls/ca/key.pem -CAcreateserial -out .tls/client/cert.pem -extfile extfile-client.cnf

# copy CA for client
cp .tls/ca/ca.pem .tls/client/ca.pem
cp .tls/ca/ca.pem .tls/server/ca.pem

# Cleanup
rm .tls/client/*.csr .tls/server/*.csr *.cnf

echo "----------"
echo "Copy content of docker-daemon-config to /etc/docker/daemon.json"
echo "And run "
echo
echo "  sudo systemctl restart docker"
echo
echo "Note: it may be necessary to update docker systemd file to remove -H option"
echo "such as in /lib/systemd/system/docker.service on Ubuntu 20"
echo
echo "Docker will now listen on tcp://0.0.0.0:2376 and require TLS Client auth"
echo
echo "Use:"
echo
echo "export DOCKER_HOST=tcp://localhost:2376"
echo "export DOCKER_CERT_PATH=${PWD}/client"
echo "export DOCKER_TLS=true"
echo "docker --tls ps"
