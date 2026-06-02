#!/bin/bash
set -e

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "Building Docker image..."
docker build --platform linux/arm64 -t roadfighter-portmaster-build "$REPO_ROOT"

echo "Extracting roadfighter.zip..."
docker run --rm --platform linux/arm64 \
    -v "$REPO_ROOT:/output" \
    roadfighter-portmaster-build \
    cp /build/roadfighter.zip /output/

echo "Done: $REPO_ROOT/roadfighter.zip"
