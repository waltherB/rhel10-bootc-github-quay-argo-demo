#!/usr/bin/env bash
set -euo pipefail
IMAGE="${IMAGE:-quay.io/waba/rhel10-bootc-demo:dev}"

podman login quay.io
podman push "$IMAGE"
