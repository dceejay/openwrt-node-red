#!/bin/sh
cd /root
#opkg list-upgradable | cut -f 1 -d ' ' | xargs opkg upgrade
opkg install node-npm
npm i -g npm@6
npm i -g --unsafe-perm node-red
mkdir -p /etc/node-red
cp node-red /etc/init.d/node-red
cp flows.json /etc/node-red/flows.json
cp flows_cred.json /etc/node-red/flows_cred.json
cd /etc/node-red
npm i node-red-node-random node-red-contrib-web-worldmap node-red-dashboard
rm -rf /usr/lib/node_modules/node-red/nodes/core/hardware
