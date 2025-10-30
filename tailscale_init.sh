#!/bin/bash
tailscaled --tun=userspace-networking \
  --socks5-server=localhost:1055 \
  --state=$HOME/.local/tailscale-data/tailscaled.state \
  --socket=$HOME/.local/tailscale-data/tailscaled.sock &

