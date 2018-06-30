#!/bin/sh
# Adjust OUTDIR to a location having a few gigs free.
# Execute manually or put this into /etc/rc.local:
# /root/pcap-collector.sh >/dev/null 2>/dev/null </dev/null &
# Requirements: netcat/nc

OUTDIR="/mnt/storage/pcap/"
for AGENTPORT in 23588 23589; do
  while true; do
    DATE="`date +%s.%N`"
    nc -d -l "$AGENTPORT" </dev/null |
    gzip --rsyncable --best > "$OUTDIR/$AGENTPORT.$DATE.pcap.gz"
  done &
done
