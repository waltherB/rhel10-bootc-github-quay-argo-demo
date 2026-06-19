#!/usr/bin/env bash
set -euo pipefail
IMAGE="${IMAGE:-quay.io/waba/bootc-guide:dev}"
PLATFORM="${TARGET_PLATFORM:-linux/arm64}"

podman login registry.redhat.io
podman build --platform "$PLATFORM" -t "$IMAGE" .
