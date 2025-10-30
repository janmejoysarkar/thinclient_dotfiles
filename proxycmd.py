#!/usr/bin/env python3
# socks5-proxycmd.py
# Usage (SSH ProxyCommand): python3 ~/bin/socks5-proxycmd.py <target_host> <target_port>
# Optional env var: SOCKS5_PROXY=host:port (default localhost:1055)

import os
import sys
import socket
import struct
import select

def fatal(msg):
    sys.stderr.write("ERROR: " + msg + "\n")
    sys.exit(1)

def parse_proxy_env():
    env = os.environ.get("SOCKS5_PROXY", "localhost:1055")
    if ":" in env:
        h, p = env.rsplit(":", 1)
        return h, int(p)
    return env, 1055

def is_ipv4(addr):
    parts = addr.split(".")
    if len(parts) != 4:
        return False
    try:
        return all(0 <= int(p) <= 255 for p in parts)
    except:
        return False

def do_socks5_connect(proxy_host, proxy_port, dst_host, dst_port):
    s = socket.create_connection((proxy_host, proxy_port))
    # Greeting: SOCKS5, 1 method, NO AUTH (0x00)
    s.sendall(b"\x05\x01\x00")
    resp = s.recv(2)
    if len(resp) != 2 or resp[0] != 0x05:
        s.close()
        fatal("bad SOCKS5 greeting from proxy")
    if resp[1] != 0x00:
        s.close()
        fatal("SOCKS5 proxy requires authentication (not supported)")

    # Build CONNECT request
    portb = struct.pack("!H", int(dst_port))
    if is_ipv4(dst_host):
        atype = b"\x01"
        addrb = socket.inet_aton(dst_host)
    else:
        atype = b"\x03"
        hostbytes = dst_host.encode()
        if len(hostbytes) > 255:
            s.close()
            fatal("hostname too long")
        addrb = bytes([len(hostbytes)]) + hostbytes

    req = b"\x05\x01\x00" + atype + addrb + portb
    s.sendall(req)

    # Reply: VER, REP, RSV, ATYP, BND.ADDR, BND.PORT
    hdr = s.recv(4)
    if len(hdr) < 4:
        s.close()
        fatal("incomplete SOCKS5 reply")
    if hdr[1] != 0x00:
        # Map common reply codes to messages (non-exhaustive)
        codes = {
            0x01: "general SOCKS server failure",
            0x02: "connection not allowed by ruleset",
            0x03: "network unreachable",
            0x04: "host unreachable",
            0x05: "connection refused",
            0x06: "TTL expired",
            0x07: "command not supported",
            0x08: "address type not supported",
        }
        msg = codes.get(hdr[1], f"SOCKS5 error {hdr[1]}")
        s.close()
        fatal("proxy connect failed: " + msg)

    atyp = hdr[3]
    if atyp == 1:
        toread = 4 + 2
    elif atyp == 3:
        # read len byte then that many bytes + 2 bytes port
        l = s.recv(1)
        if not l:
            s.close()
            fatal("incomplete SOCKS5 reply (domain len)")
        llen = l[0]
        rest = s.recv(llen + 2)
        if len(rest) != llen + 2:
            s.close()
            fatal("incomplete SOCKS5 reply (domain)")
        # success
    elif atyp == 4:
        toread = 16 + 2
        rest = s.recv(toread)
        if len(rest) != toread:
            s.close()
            fatal("incomplete SOCKS5 reply (IPv6)")
    else:
        s.close()
        fatal("unknown ATYP in SOCKS5 reply")
    # If we took the domain branch, we already read the rest; otherwise consume it now
    if atyp in (1,4):
        rest = s.recv(toread)
        if len(rest) != toread:
            s.close()
            fatal("incomplete SOCKS5 reply (addr/port)")

    # Now the socket 's' is connected to destination. Return it.
    return s

def bridge_socket_and_stdio(sock):
    sock_fd = sock.fileno()
    stdin_fd = sys.stdin.fileno()
    stdout_fd = sys.stdout.fileno()

    # Set stdin/out to binary mode (they already are in Python3)
    # Loop until both ends close
    stdin_open = True
    while True:
        rlist = []
        if stdin_open:
            rlist.append(stdin_fd)
        rlist.append(sock_fd)
        if not rlist:
            break
        try:
            r, _, _ = select.select(rlist, [], [])
        except select.error:
            break

        if sock_fd in r:
            data = sock.recv(4096)
            if not data:
                # remote closed
                break
            os.write(stdout_fd, data)

        if stdin_open and stdin_fd in r:
            try:
                data = os.read(stdin_fd, 4096)
            except OSError:
                data = b""
            if not data:
                # stdin closed (EOF) — signal to socket we won't send more
                try:
                    sock.shutdown(socket.SHUT_WR)
                except:
                    pass
                stdin_open = False
            else:
                sock.sendall(data)
    try:
        sock.close()
    except:
        pass

def main():
    if len(sys.argv) < 3:
        sys.stderr.write("Usage: socks5-proxycmd.py <target_host> <target_port>\n")
        sys.exit(2)
    dst_host = sys.argv[1]
    dst_port = sys.argv[2]
    proxy_host, proxy_port = parse_proxy_env()
    try:
        sock = do_socks5_connect(proxy_host, proxy_port, dst_host, dst_port)
    except Exception as e:
        fatal(str(e))
    bridge_socket_and_stdio(sock)

if __name__ == "__main__":
    main()

