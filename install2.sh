#!/bin/bash

echo install service
systemctl --user enable boot_pi.service

echo check ovs
cd openvswitch-2.16.2/datapath/linux/
modprobe openvswitch
cd ../..

echo add files
touch /usr/local/etc/ovs-vswitchd.conf
mkdir -p /usr/local/etc/openvswitch
ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema

/etc/init.d/superscript

echo show ovs
ovs-vsctl show

echo create ovs bridge
ovs-vsctl add-br br0

echo add interfaces to openflow
ovs-vsctl add-port br0 eth0
ovs-vsctl add-port br0 eth1
ovs-vsctl add-port br0 eth2
ovs-vsctl add-port br0 eth3

echo add openflow controller
ovs-vsctl set-controller br0 tcp:192.168.8.18:6633
ovs-vsctl set bridge br0 protocols=OpenFlow10
