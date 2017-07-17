#!/bin/bash



INT_WIFI="wlan0"
INT_NET="eth0"

IP="192.168.33.1"
CID="24"
NETWORK="192.168.33.0/24"
DHCP_RANGE="192.168.33.100,192.168.33.254,255.255.255.0,4h"

SSID="PIWIFI"
CHANNEL="6"
PASS_PHRASE="LastWhiteN8"
DRIVER=nl80211

ip addr add $IP/$CID dev $INT_NET
sleep 3
echo 1 > /proc/sys/net/ipv4/ip_forward

modprobe ipt_MASQUERADE

iptables -A POSTROUTING -t nat -o $INT_NET -j MASQUERADE
iptables -A FORWARD --match state --state RELATED,ESTABLISHED --jump ACCEPT
iptables -A FORWARD -i $INT_WIFI --destination $NETWORK --match state --state NEW --jump ACCEPT
iptables -A INPUT -s $NETWORK --jump ACCEPT

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


#STARTING
killall dnsmasq
killall hostapd
echo -e "INTERFACE: $INT_WIFI \nSSID:$SSID Channel:$CHANNEL\nKEY: $PASS_PHRASE\n"
echo "STARTING DNSMASQ"
dnsmasq   -C /tmp/dnsmasq.conf &
echo "STARTING HOSTAPD" 
hostapd   /tmp/hostapd.conf 

#CLEANING
killall dnsmasq
iptables -D POSTROUTING -t nat -o $INT_NET -j MASQUERADE
iptables -D FORWARD --match state --state RELATED,ESTABLISHED --jump ACCEPT
iptables -D FORWARD -i $INT_WIFI --destination $NETWORK --match state --state NEW --jump ACCEPT
iptables -D INPUT -s $NETWORK --jump ACCEPT

echo -e "\nTERMINATED\n\n" 
