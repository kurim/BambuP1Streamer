#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

VERSION=$1

# Build images for different architectures
docker build -t kur1m/p1stream-ha:amd64 -f Dockerfile.amd64 .
docker build -t kur1m/p1stream-ha:arm64 -f Dockerfile.arm64 --platform linux/arm64 .

# Push the images to the Docker registry
docker push kur1m/p1stream-ha:amd64
docker push kur1m/p1stream-ha:arm64

# Create the manifest
docker manifest create kur1m/p1stream-ha:$VERSION \
    kur1m/p1stream-ha:amd64 \
    kur1m/p1stream-ha:arm64

docker manifest annotate kur1m/p1stream-ha:$VERSION \
    kur1m/p1stream-ha:amd64 --os linux --arch amd64

docker manifest annotate kur1m/p1stream-ha:$VERSION \
    kur1m/p1stream-ha:arm64 --os linux --arch arm64

# Push the manifest to the Docker registry
docker manifest push kur1m/p1stream-ha:$VERSION