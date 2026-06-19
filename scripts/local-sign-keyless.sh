#!/usr/bin/env bash
set -euo pipefail
IMAGE="${IMAGE:-quay.io/waba/rhel10-bootc-demo:dev}"

# Requires: brew install cosign
# For private Quay repositories, ensure you are logged in with podman login quay.io.
COSIGN_YES=true cosign sign "$IMAGE"
cosign verify "$IMAGE" \
  --certificate-identity-regexp '.*' \
  --certificate-oidc-issuer-regexp '.*'
