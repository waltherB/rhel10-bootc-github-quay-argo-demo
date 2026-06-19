#!/usr/bin/env bash
set -euo pipefail
IMAGE="${1:-quay.io/waba/rhel10-bootc-demo:prod}"

sudo bootc switch --apply "$IMAGE"
