# Raspberry-Pi-OpenvSwitch-OvS-OpenFlow
This repo documents the installation of OpenvSwitch aka OvS on Raspberry Pi Zero W and Pi Zero 2 Hardware

**Operating System:**
Raspberry Pi OS Bullseye
All Updates as of 07.01.2022

**To remove the need to always enter sudo:**
sudo su

**These Packages where installed:**
apt-get install libssl-dev automake autoconf gcc uml-utilities libtool build-essential pkg-config
apt-get install apparmor dns-root-data libssl-dev libunbound8 raspberrypi-kernel-headers snapd squashfs-tools unbound unbound-anchor

**Download and Extract OpenvSwitch (Version 2.16.1 in this case):**
wget https://www.openvswitch.org/releases/openvswitch-2.16.1.tar.gz
tar -xvzf openvswitch-2.16.1.tar.gz

**Create Directories:**
cd /usr/local
mkdir var
cd var/
mkdir run
cd run/
mkdir openvswitch

**Go back to the OpenvSwitch dir downloaded earlier:**
cd ../../../..
cd home/pi/openvswitch-2.16.1

**Install OpenvSwitch:**
./configure
make -j4
make -j4 install

**Reboot and turn on module:**
reboot
cd openvswitch-2.16.1/datapath/linux/
modprobe openvswitch

**Exit Module dir and create files & dirs:**
cd ../..
touch /usr/local/etc/ovs-vswitchd.conf
mkdir -p /usr/local/etc/openvswitch
ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema

**Create Superscript:**
sudo nano /etc/init.d/superscript
with following content:
ovsdb-server    --remote=punix:/usr/local/var/run/openvswitch/db.sock \
                --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
                --private-key=db:Open_vSwitch,SSL,private_key \
                --certificate=db:Open_vSwitch,SSL,certificate \
                --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
                --pidfile --detach
ovs-vsctl --no-wait init
ovs-vswitchd --pidfile --detach

**Make script executeable and run it:**
chmod +x /etc/init.d/superscript
/etc/init.d/superscript

First References:

https://sumitrokgp.wordpress.com/2017/05/18/converting-a-raspberry-pi-to-a-openflow-switch/
https://gist.github.com/exelban/c932d9c42094050b466eb6ba91956dbf#file-open-vswitch-raspberry-pi

~~For in-band connection to SDN Controller add (when in userspace):
ovs-vsctl set bridge br0 datapath_type=netdev~~
