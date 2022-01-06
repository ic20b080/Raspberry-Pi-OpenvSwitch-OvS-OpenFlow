# Raspberry-Pi-OpenvSwitch-OvS-OpenFlow
This repo documents the installation of OpenvSwitch aka OvS on Raspberry Pi Zero W and Pi Zero 2 Hardware

First References:

https://sumitrokgp.wordpress.com/2017/05/18/converting-a-raspberry-pi-to-a-openflow-switch/
https://gist.github.com/exelban/c932d9c42094050b466eb6ba91956dbf#file-open-vswitch-raspberry-pi

For in-band connection to SDN Controller add (when in userspace):
ovs-vsctl set bridge br0 datapath_type=netdev
