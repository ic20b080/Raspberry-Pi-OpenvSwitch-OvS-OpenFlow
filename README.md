# Raspberry-Pi-OpenvSwitch-OvS-OpenFlow
This repo documents the installation of OpenvSwitch aka OvS on Raspberry Pi Zero W and Pi Zero 2 Hardware

## Operating System:
Raspberry Pi OS Bullseye 32 bit from 28th Jan 2022

## How to install (script solution):
1. Make install1.sh executable with the following commmand: sudo chmod +x install1.sh
2. Execute the install1.sh script. Navigate to the folder with the file and execute it with sudo ./install1.sh
3. Execute the install2.sh script (after install1.sh rebooted the system). Navigate to the folder with the file and execute it with sudo ./install2.sh
4. OvS should run on every startup


## How to install (step by step):

### To remove the need to always enter sudo:
sudo su

### These Packages where installed:
apt-get install libssl-dev automake autoconf gcc uml-utilities libtool build-essential pkg-config

apt-get install apparmor dns-root-data libssl-dev libunbound8 raspberrypi-kernel-headers snapd squashfs-tools unbound unbound-anchor

### Download and Extract OpenvSwitch (Version 2.16.2 in this case):
wget https://www.openvswitch.org/releases/openvswitch-2.16.2.tar.gz

tar -xvzf openvswitch-2.16.2.tar.gz

### Create Directories:
cd /usr/local

mkdir -p var/run/openvswitch

### Go back to the OpenvSwitch dir downloaded earlier:
cd ../..

cd home/pi/openvswitch-2.16.2

### Install OpenvSwitch:
./configure

make -j4

make -j4 install

### Reboot and turn on module:
reboot

sudo su

cd openvswitch-2.16.2/datapath/linux/

modprobe openvswitch

### Exit Module dir and create files & dirs:
cd ../..

touch /usr/local/etc/ovs-vswitchd.conf

mkdir -p /usr/local/etc/openvswitch

ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema

### Create Superscript:
nano /etc/init.d/superscript

**with following content:**

#!/bin/bash

ovsdb-server    --remote=punix:/usr/local/var/run/openvswitch/db.sock \
                --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
                --private-key=db:Open_vSwitch,SSL,private_key \
                --certificate=db:Open_vSwitch,SSL,certificate \
                --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
                --pidfile --detach
ovs-vsctl --no-wait init
ovs-vswitchd --pidfile --detach

### Make script executable and run it:
chmod +x /etc/init.d/superscript

/etc/init.d/superscript

## Configure OpenvSwitch

### Check OpenvSwitch:
ovs-vsctl show

### Add Bridge:
ovs-vsctl add-br br0

### Add Ports:
ovs-vsctl add-port br0 eth0

ovs-vsctl add-port br0 eth1

ovs-vsctl add-port br0 eth2

ovs-vsctl add-port br0 eth3

### Disable DHCP client
service dhcpcd stop

### Remove IP-Addresses on phsical interfaces:
I had an IP-Address assigned on eth0:

ifconfig eth0 0

### Add IP-Address to br0 bridge interface:
I have an 192.168.1.x network

ifconfig br0 192.168.1.99 netmask 255.255.255.0 up

### Setup routes
I have an 192.168.1.x network therefor I need these routes

Destination     Gateway         Genmask         Flags Metric Ref    Use Iface

0.0.0.0         192.168.1.1     0.0.0.0         UG    0      0        0 br0

192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0 br0


I only had the second route so I added the other with

route add -net 0.0.0.0 gw 192.168.1.1 netmask 0.0.0.0 dev br0

### Add Controller:
ovs-vsctl set-controller br0 tcp:192.168.1.110:6633

I had to set a specific OpenFlow Version

ovs-vsctl set bridge br0 protocols=OpenFlow10


## First References:

https://sumitrokgp.wordpress.com/2017/05/18/converting-a-raspberry-pi-to-a-openflow-switch/
https://gist.github.com/exelban/c932d9c42094050b466eb6ba91956dbf#file-open-vswitch-raspberry-pi
