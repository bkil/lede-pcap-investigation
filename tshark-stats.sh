#!/bin/sh
# Requirements: tshark

main() {
  if [ $# -ne 2 ]; then
    echo "usage: $0 [in.pcap] [out.txt]" >&2
    exit 1
  fi
  local PCAP="$1"
  local OUT="$2"

  tshark \
    -z conv,wlan \
    -z endpoints,wlan \
    -z expert,wlan \
    -z io,stat,60 \
    -z io,phs \
    -z io,stat,0,"SUM(wlan_radio.duration)wlan_radio.duration" \
    -r "$PCAP" -w /dev/null \
    "not wlan.fcs.status==0" \
    > "$OUT"
}

main "$@"
