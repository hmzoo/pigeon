#!/bin/bash



INT_WIFI="wlan0"
INT_NET="eth0"

IP="192.168.33.1"
CID="24"
MASK="255.255.255.0"

DHCP_RANGE="192.168.33.100,192.168.33.254,255.255.255.0,4h"

SSID="PIWIFI"
CHANNEL="6"
PASS_PHRASE="LastWhiteNight"
DRIVER=nl80211

ip addr add $IP/$CID dev $INT_WIFI
echo 1 > /proc/sys/net/ipv4/ip_forward


cat <<EOT > /tmp/dnsmasq.conf
domain-needed
bogus-priv
interface=$INT_WIFI
dhcp-range=$DHCP_RANGE
EOT

cat <<EOT > /tmp/hostapd.conf
interface=$INT_WIFI
driver=$DRIVER
ssid=$SSID
hw_mode=g
channel=$CHANNEL
macaddr_acl=0
auth_algs=2
wpa=3
wpa_passphrase=$PASS_PHRASE
EOT

dnsmasq -x /var/run/dnsmasq.pid -C /tmp/dnsmasq.conf
hostapd -B -P /var/run/hostapd.pid /tmp/hostapd.conf
