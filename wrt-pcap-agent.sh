#!/bin/sh
# Replace XCOLLECTORIP with the host you store the traces on.
# Replace XAGENTPORT with unique listen port (ie., 23588).
# Add a monitoring interface to your WLAN NIC first.
# Put this into /etc/rc.local:
# /root/wrt-pcap-agent.sh XCOLLECTORIP XAGENTPORT >/dev/null 2>/dev/null </dev/null &
# Requirements: tcpdump (tcpdump-mini, libpcap)

COLLECTORIP="$1"
AGENTPORT="$2"
HEADERBYTES=100 # need at least radiotap + 28B for 802.11
while true; do
  tcpdump \
    --buffer-size=1024 \
    --snapshot-length="$HEADERBYTES" \
    --interface=wlan0 \
    -w - |
  nc "$COLLECTORIP" "$AGENTPORT"

  sleep 1
done
