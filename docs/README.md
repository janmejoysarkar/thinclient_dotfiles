# Dotfiles for client machines
This repository holds the bare minimum to get my development setup up and running anywhere, in any linux machine for which I do not have `sudo` access.

## Required packages:
- `tmux`
- `vim`

## Other packages:
These packages can be installed locally with manual intervention.
- `google-chrome`
- `rclone`
- `nodejs` (for coc in vim)

## Custom files:
- `proxycmd.py` helps generate `ProxyCommand` for ssh communication over SOCKS5 (port 1055).
- Note that this is necessary because tailscale can run in userspace only through the SOCKS5 port.
- Establish ssh over proxy as such
```
ssh -o "ProxyCommand=~/bin/socks5-proxycmd.py %h %p" user@100.117.202.119
```
## Screenshots
- ![terminal](./README_files/screenshot.png)
