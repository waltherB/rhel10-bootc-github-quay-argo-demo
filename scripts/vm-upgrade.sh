#!/usr/bin/env bash
# Run this INSIDE the VM to pull the latest :prod image and reboot into it.
set -euo pipefail

echo "=== Current booted image ==="
sudo bootc status

echo ""
echo "=== Checking for update ==="
sudo bootc upgrade --check

echo ""
echo "=== Pulling and staging new image ==="
sudo bootc upgrade

echo ""
echo "=== Rebooting into new image in 5 seconds (Ctrl-C to cancel) ==="
sleep 5
sudo systemctl reboot
