#!/bin/bash

echo check ovs
cd openvswitch-2.16.2/datapath/linux/
modprobe openvswitch

echo start ovs 
cd ../..
/etc/init.d/superscript

echo stop dhcp client
service dhcpcd stop

echo remove ipv4 adresses from physical interfaces
ifconfig eth0 0 up
ifconfig eth1 0 up
ifconfig eth2 0 up
ifconfig eth3 0 up

echo remove ipv6 adresses from physical interfaces
if [[ $(ifconfig eth0 |  awk '/inet6/{print $2}') ]]; then
  echo eth0 has ipv6
  ifconfig eth0 inet6 del $(ifconfig eth0 |  awk '/inet6/{print $2}')/$(ifconfig eth0 |  awk '/inet6/{print $4}')
else
  echo eth0 no ipv6
fi

if [[ $(ip addr show dev eth1 | sed -e's^.*inet6 \([^ ]*\)\/.*S/\1/;t;d') ]]; then
  echo eth1 has ipv6
  ifconfig eth1 inet6 del $(ifconfig eth1 |  awk '/inet6/{print $2}')/$(ifconfig eth1 |  awk '/inet6/{print $4}')
else
  echo eth1 no ipv6
fi

if [[ $(ip addr show dev eth2 | sed -e's^.*inet6 \([^ ]*\)\/.*S/\1/;t;d') ]]; then
  echo eth2 has ipv6
  ifconfig eth2 inet6 del $(ifconfig eth2 |  awk '/inet6/{print $2}')/$(ifconfig eth2 |  awk '/inet6/{print $4}')
else
  echo eth2 no ipv6
fi

if [[ $(ip addr show dev eth3 | sed -e's^.*inet6 \([^ ]*\)\/.*S/\1/;t;d') ]]; then
  echo eth3 has ipv6
  ifconfig eth3 inet6 del $(ifconfig eth3 |  awk '/inet6/{print $2}')/$(ifconfig eth3 |  awk '/inet6/{print $4}')
else
  echo eth3 no ipv6
fi
