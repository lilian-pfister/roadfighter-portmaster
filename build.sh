#!/bin/bash
set -e

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "Building Docker image..."
docker build --platform linux/arm64 -t roadfighter-portmaster-build "$REPO_ROOT"

echo "Extracting roadfighter.zip..."
CONTAINER=$(docker create --platform linux/arm64 roadfighter-portmaster-build)
docker cp "$CONTAINER:/build/roadfighter.zip" "$REPO_ROOT/"
docker rm "$CONTAINER" > /dev/null

echo "Done: $REPO_ROOT/roadfighter.zip"
