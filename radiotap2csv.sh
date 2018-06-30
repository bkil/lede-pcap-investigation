#!/bin/sh
# Requirements: tshark, xz (xz-utils)

main() {
  if [ "$1" = "-debug" ] ; then
    shift 1
    local DEBUG="1"
    local ADDARGS="-e wlan.bssid -e wlan.ta -e wlan.ra -e wlan.sa -e wlan.da"
  fi
  if [ $# -ne 2 ]; then
    echo "usage: $0 input_pcap output_csv_xz" >&2
    exit 1
  fi
  local PCAP="$1"
  local CSV="$2"

  tshark \
    -e frame.time_epoch \
    -e radiotap.mactime \
    -e frame.len \
    -e wlan_radio.duration \
    -e wlan_radio.preamble \
    -e wlan_radio.phy \
    -e wlan.fc.type_subtype \
    -e wlan.flags \
    -e wlan.duration \
    -e wlan.seq \
    -e radiotap.datarate \
    -e radiotap.flags \
    -e radiotap.channel.flags \
    -e radiotap.xchannel.flags \
    -e radiotap.rxflags.badplcp \
    -e radiotap.dbm_antsignal \
    -e radiotap.mcs.bw \
    -e radiotap.mcs.gi \
    -e radiotap.mcs.format \
    -e radiotap.mcs.fec \
    -e radiotap.mcs.stbc \
    -e radiotap.mcs.index \
    -e radiotap.ampdu.reference \
    -e radiotap.ampdu.flags \
    -e wlan.ba.type \
    -e wlan.ba.control \
    -e wlan.ba.basic.tidinfo \
    -e wlan.ba.mtid.tidinfo \
    -e wlan.ba.mtid.tid \
    -e wlan.ba.bm \
    -e wlan.ba.RBUFCAP \
    -e wlan.ba.bm.missing_frame \
    -e wlan.bar.type \
    -e wlan.bar.control \
    -e wlan.bar.compressed.tidinfo \
    -e wlan.bar.mtid.tidinfo.value \
    -e wlan_mgt.fixed.ssc \
    -e wlan_mgt.fixed.capabilities \
    -e wlan_mgt.fixed.auth_seq \
    -e wlan_mgt.fixed.timestamp \
    -e wlan_mgt.erp_info \
    -e wlan_mgt.tim.bmapctl \
    -e wlan_mgt.tim.bmapctl.multicast \
    -e wlan_mgt.tim.bmapctl.offset \
    -e wlan_mgt.tim.partial_virtual_bitmap \
    -e wlan.tim.aid \
    $ADDARGS \
    -E separator=";" -E header=y -T fields \
    -r "$PCAP" |
  trim_leading_zeros |
  if [ -n "$DEBUG" ]; then
    cat
  else
    xz
  fi > "$CSV"
}

trim_leading_zeros() {
 sed -r "s/0x0+([0-9a-fA-F])/0x\1/g" "$@"
}

main "$@"
