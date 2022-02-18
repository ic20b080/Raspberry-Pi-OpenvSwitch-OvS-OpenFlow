#!/bin/bash

echo check ovs
cd openvswitch-2.16.2/datapath/linux/
sudo modprobe openvswitch

echo start ovs 
cd ../..
sudo /etc/init.d/superscript

echo probe for propper IPv4 Address

while true
do
  ip=$(ifconfig br0 | grep "inet " |  awk '{print $2}')
  echo $ip
  if [[ !(-z "$ip") && !("${ip:0:7}" == *"169.254"*) ]]
  then
    echo exit loop
    break
  else
    echo restart dhcp client
    sudo service dhcpcd stop
    sudo service dhcpcd start
    sleep 20
  fi
done

echo stop dhcp client
sudo service dhcpcd stop

echo remove ipv4 adresses from physical interfaces
sudo ifconfig eth0 0 up
sudo ifconfig eth1 0 up
sudo ifconfig eth2 0 up
sudo ifconfig eth3 0 up

echo remove ipv6 adresses from physical interfaces
if [[ $(ifconfig eth0 | grep "inet6 " |  awk '{print $2}') ]]; then
  echo eth0 has ipv6
  IFS=$' ' read -a arrayIP0 <<< $(echo $(ifconfig eth0 | grep "inet6 " |  awk '{print $2}'))
  IFS=$' ' read -a arrayMask0 <<< $(echo $(ifconfig eth0 | grep "inet6 " |  awk '{print $4}'))

  echo "${#arrayIP0[@]}"

  for index in "${!arrayIP0[@]}"
  do
    sudo ifconfig eth0 inet6 del "${arrayIP0[index]}/${arrayMask0[index]}"
  done
else
  echo eth0 no ipv6
fi

if [[ $(ifconfig eth1 | grep "inet6 " |  awk '{print $2}') ]]; then
  echo eth1 has ipv6
  IFS=$' ' read -a arrayIP1 <<< $(echo $(ifconfig eth1 | grep "inet6 " |  awk '{print $2}'))
  IFS=$' ' read -a arrayMask1 <<< $(echo $(ifconfig eth1 | grep "inet6 " |  awk '{print $4}'))

  echo "${#arrayIP1[@]}"

  for index in "${!arrayIP1[@]}"
  do
    sudo ifconfig eth1 inet6 del "${arrayIP1[index]}/${arrayMask1[index]}"
  done
else
  echo eth1 no ipv6
fi

if [[ $(ifconfig eth2 | grep "inet6 " |  awk '{print $2}') ]]; then
  echo eth2 has ipv6
  IFS=$' ' read -a arrayIP2 <<< $(echo $(ifconfig eth2 | grep "inet6 " |  awk '{print $2}'))
  IFS=$' ' read -a arrayMask2 <<< $(echo $(ifconfig eth2 | grep "inet6 " |  awk '{print $4}'))

  echo "${#arrayIP2[@]}"

  for index in "${!arrayIP2[@]}"
  do
    sudo ifconfig eth2 inet6 del "${arrayIP2[index]}/${arrayMask2[index]}"
  done
else
  echo eth2 no ipv6
fi

if [[ $(ifconfig eth3 | grep "inet6 " |  awk '{print $2}') ]]; then
  echo eth3 has ipv6
  IFS=$' ' read -a arrayIP3 <<< $(echo $(ifconfig eth3 | grep "inet6 " |  awk '{print $2}'))
  IFS=$' ' read -a arrayMask3 <<< $(echo $(ifconfig eth3 | grep "inet6 " |  awk '{print $4}'))

  echo "${#arrayIP3[@]}"

  for index in "${!arrayIP3[@]}"
  do
    echo ifconfig eth3 inet6 del "${arrayIP3[index]}/${arrayMask3[index]}"
  done
else
  echo eth3 no ipv6
fi
