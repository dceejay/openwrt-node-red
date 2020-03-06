#!/bin/sh
###
###  There are some custom commands here to get things working on my system. 
###  Please check to see if they are appropiate for you before using
###
cd /root
#opkg list-upgradable | cut -f 1 -d ' ' | xargs opkg upgrade
opkg install node-npm
npm i -g npm
npm i -g --unsafe-perm node-red
mkdir -p /etc/node-red
cp /usr/src/openwrt-node-red/node-red /etc/init.d/node-red
cp /usr/src/openwrt-node-red/flows.json /etc/node-red/flows.json
cp /usr/src/openwrt-node-red/flows_cred.json /etc/node-red/flows_cred.json
cp -R /usr/src/openwrt-node-red/luci/* /usr/lib/lua/luci/
cd /etc/node-red
npm i node-red-node-random node-red-contrib-web-worldmap node-red-dashboard bufferutil utf-8-validate
rm -rf /usr/lib/node_modules/node-red/nodes/core/hardware
