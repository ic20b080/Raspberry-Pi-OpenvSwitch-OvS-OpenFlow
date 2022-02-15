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
if [[ $(ifconfig eth0 | awk '/inet6/{print $2}') ]]; then
  echo eth0 has ipv6
  IFS=$' ' read -a arrayIP0 <<< $(echo $(ifconfig eth0 | awk '/inet6/{print $2}'))
  IFS=$' ' read -a arrayMask0 <<< $(echo $(ifconfig eth0 | awk '/inet6/{print $4}'))

  echo "${#arrayIP0[@]}"

  for index in "${!arrayIP0[@]}"
  do
    ifconfig eth0 inet6 del "${arrayIP0[index]}/${arrayMask0[index]}"
  done
else
  echo eth0 no ipv6
fi

if [[ $(ifconfig eth1 | awk '/inet6/{print $2}') ]]; then
  echo eth1 has ipv6
  IFS=$' ' read -a arrayIP1 <<< $(echo $(ifconfig eth1 | awk '/inet6/{print $2}'))
  IFS=$' ' read -a arrayMask1 <<< $(echo $(ifconfig eth1 | awk '/inet6/{print $4}'))

  echo "${#arrayIP1[@]}"

  for index in "${!arrayIP1[@]}"
  do
    ifconfig eth1 inet6 del "${arrayIP1[index]}/${arrayMask1[index]}"
  done
else
  echo eth1 no ipv6
fi

if [[ $(ifconfig eth2 | awk '/inet6/{print $2}') ]]; then
  echo eth2 has ipv6
  IFS=$' ' read -a arrayIP2 <<< $(echo $(ifconfig eth2 | awk '/inet6/{print $2}'))
  IFS=$' ' read -a arrayMask2 <<< $(echo $(ifconfig eth2 | awk '/inet6/{print $4}'))

  echo "${#arrayIP2[@]}"

  for index in "${!arrayIP2[@]}"
  do
    ifconfig eth2 inet6 del "${arrayIP2[index]}/${arrayMask2[index]}"
  done
else
  echo eth2 no ipv6
fi

if [[ $(ifconfig eth3 | awk '/inet6/{print $2}') ]]; then
  echo eth3 has ipv6
  IFS=$' ' read -a arrayIP3 <<< $(echo $(ifconfig eth3 | awk '/inet6/{print $2}'))
  IFS=$' ' read -a arrayMask3 <<< $(echo $(ifconfig eth3 | awk '/inet6/{print $4}'))

  echo "${#arrayIP3[@]}"

  for index in "${!arrayIP3[@]}"
  do
    ifconfig eth3 inet6 del "${arrayIP3[index]}/${arrayMask3[index]}"
  done
else
  echo eth3 no ipv6
fi
