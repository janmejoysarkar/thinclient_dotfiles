#!/bin/bash
~/tailscale/tailscaled \
  --state=$HOME/tailscale/tailscaled.state \
  --socket=$HOME/tailscale/tailscaled.sock \
  --tun=userspace-networking \
  --socks5-server=localhost:1055 \
  --outbound-http-proxy-listen=localhost:1055


