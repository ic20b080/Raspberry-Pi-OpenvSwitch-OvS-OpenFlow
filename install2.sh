#!/bin/bash

echo install service
cd ~/.config/systemd/user/
systemctl --user enable boot_pi.service
cd ../../..

echo check ovs
cd openvswitch-2.16.2/datapath/linux/
sudo modprobe openvswitch
cd ../..

echo add files
sudo touch /usr/local/etc/ovs-vswitchd.conf
sudo mkdir -p /usr/local/etc/openvswitch
sudo ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema

echo start ovs
sudo /etc/init.d/superscript

echo show ovs
sudo ovs-vsctl show

echo create ovs bridge
sudo ovs-vsctl add-br br0

echo add interfaces to openflow
sudo ovs-vsctl add-port br0 eth0
sudo ovs-vsctl add-port br0 eth1
sudo ovs-vsctl add-port br0 eth2
sudo ovs-vsctl add-port br0 eth3

echo add openflow controller
sudo ovs-vsctl set-controller br0 tcp:192.168.8.18:6633
sudo ovs-vsctl set bridge br0 protocols=OpenFlow14

echo reboot
reboot
