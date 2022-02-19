#!/bin/bash

echo install required packages
sudo apt-get update
sudo apt-get install -y libssl-dev automake autoconf gcc uml-utilities libtool build-essential pkg-config

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
sudo ./configure
sudo make -j4
sudo make -j4 install

echo make files executable
sudo chmod +x superscript
sudo chmod +x boot_pi.service
sudo chmod +x install2.sh

echo move superscript
sudo mv superscript /etc/init.d

echo create service folder and move boot script
sudo mkdir -p ~/.config/systemd/user
sudo mv boot_pi.service ~/.config/systemd/user

echo reboot system
reboot
