#!/usr/bin/env bash
set -euo pipefail
IMAGE="${IMAGE:-quay.io/waba/rhel10-bootc-demo:dev}"
PLATFORM="${TARGET_PLATFORM:-linux/arm64}"

podman login registry.redhat.io
podman build --platform "$PLATFORM" -t "$IMAGE" .
