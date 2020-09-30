#!/bin/bash

VERSION=$(cat PROJECT_VERSION | grep -oP '(?<="version": ")[^"]*')
export VERSION
# build all images
docker build -t terrabrasilis/nginx-manager:v$VERSION --build-arg VERSION=$VERSION -f Dockerfile .

# send to dockerhub
docker login
docker push terrabrasilis/nginx-manager:v$VERSION
