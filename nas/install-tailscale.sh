#!/bin/sh

if type tailscale >/dev/null 2>&1; then
  echo "Already installed tailscale" >&2
  exit 1
fi
if [ ! -e tailscale.spk ]; then
  curl https://pkgs.tailscale.com/stable/tailscale-armv8-1.90.9-700090009-dsm7.spk --output tailscale.spk
fi
sudo synopkg install tailscale.spk
