#!/usr/bin/env sh

set -e

# Small script to run everything and check it works

# Nix
nix shell nixpkgs#podman-compose -c podman-compose up -d
nix develop -c sh -c \
    "echo 'It works' && env | grep AWS && env | grep MYSQL && env | grep NPM_TOKEN && podman-compose down -v"

# Podman
nix shell nixpkgs#podman-compose -c podman-compose up -d
nix shell nixpkgs#podman-compose -c podman-compose -f docker-compose.dev-container.yml run dev-container
nix shell nixpkgs#podman-compose -c podman-compose -f docker-compose.dev-container.yml down -v
nix shell nixpkgs#podman-compose -c podman-compose down -v

