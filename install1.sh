#!/bin/bash

echo enter superuser mode
sudo su

echo install required packages
apt-get update
apt-get install -y libssl-dev automake autoconf gcc uml-utilities libtool build-essential pkg-config

echo download openvswitch
wget https://www.openvswitch.org/releases/openvswitch-2.16.2.tar.gz

echo extract openvswitch
tar -xvzf openvswitch-2.16.2.tar.gz

echo create folder
cd /usr/local
mkdir -p var/run/openvswitch

echo go to openvswitch folder
cd ../..
cd home/pi/openvswitch-2.16.2

echo install openvswitch
./configure
make -j4
make -j4 install

echo reboot system
reboot
