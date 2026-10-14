# Flush the macOS DNS cache (after a router, DNS or /etc/hosts change).
flush-dns() {
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}
