#!/bin/bash


apt-get install -y hostapd

cp ./hostapd.conf /etc/hostapd/hostapd.conf

echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" >> /etc/default/hostapd

cp ./interfaces /etc/network/interfaces

