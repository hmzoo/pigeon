#!/bin/bash


apt-get install dnsmasq hostapd
update-rc.d dnsmasq disable
update-rc.d hostapd disable
sed -i -e 's/ENABLED=1/ENABLED=0/' /etc/default/dnsmasq

  
