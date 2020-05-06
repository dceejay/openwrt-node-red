# openwrt-node-red

[![platform](https://img.shields.io/badge/platform-Node--RED-red)](https://nodered.org)

A packaging up of Node-RED for OpenWRT.

The `dist` directory contains the .ipk file you need to download and install. For example

    opkg install node-red_1.0.6.ipk


### Build scripts

The scripts can help you to recreate this yourself.

 - **buildNR.sh** - installs node.js and then Node-RED from npm and then several extra nodes into `/etc/node-red`. This is where you can add your customised nodes.
 - **ipk-pack.sh** - removes un-needed cruft, creates needed control files, and then creates the .ipk file
 - **packit** - a helper script that can be run on your host machine to automate the packaging by copying the necessary files to the target device, then calling ipk-pack, and then copying the created file back to your host.

### Other files

 - **flows.json, flows_cred.json** - Default flow file to load - Customise this if you want to start with something special.
 - **node-red** - the init.d script that starts and stops Node-RED as a service.

### OpenWRT admin menu - Luci files

OpenWRT uses Luci as it's admin web UI. The files in the `luci` directory can be used to add Node-RED to the admin menu so you can easily see the log (usually at `/var/log/node-red.log`).

The `addluci.sh` script will copy them into the correct place (as of Oct 2018), you will need to restart luci (or reboot).

The `status.lua` file currently just copies over the existing one. This may cause problems in the future if the order of items in the default file changes. There doesn't seem to be a good way to contribute an entry dynamically on install. Thus we don't automatically install these files for you. You may need to merge them manually.
