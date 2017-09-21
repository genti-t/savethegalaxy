#!/bin/bash

set -e

export CADDY_VERSION="0.10.9"
export HUB_REPO="genti/savethegalaxy"
export VERSION="0.1"

echo "Download and extract caddy ..."
wget https://github.com/mholt/caddy/releases/download/v${CADDY_VERSION}/caddy_v${CADDY_VERSION}_linux_amd64.tar.gz
tar -zxvf caddy_v${CADDY_VERSION}_linux_amd64.tar.gz caddy

echo "Building caddy docker image ..."
docker build -t ${HUB_REPO}:v${VERSION} .

echo "Pushing the docker image on dockerhub"
docker push ${HUB_REPO}:v${VERSION}

echo "Cleaning ..."
rm -rfv caddy*
