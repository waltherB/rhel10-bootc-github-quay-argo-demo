#!/usr/bin/env bash
set -euo pipefail
IMAGE="${IMAGE:-quay.io/waba/bootc-guide:dev}"

podman rm -f bootc-test 2>/dev/null || true
podman run --rm -d -p 8080:80 --name bootc-test "$IMAGE"
curl -fsS http://127.0.0.1:8080 | head
podman exec bootc-test cat /etc/motd
podman stop bootc-test
