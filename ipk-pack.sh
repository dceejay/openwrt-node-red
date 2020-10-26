#!/bin/sh

echo ""
VER=$(node-red -? | grep RED | cut -d "v" -f 2)
echo "NODE-RED VERSION is "$VER

echo -e "\nTidy up"
cd /usr/lib/node_modules
 find . -type f -name .DS_Store -exec rm {} \;
 # find . -not -newermt 1971-01-01 -exec touch {} \;

cd /usr/lib/node_modules/node-red/node_modules
 find . -type d -name test -exec rm -r {} \;
 find . -type d -name doc -exec rm -r {} \;
#  find . -type d -name example* -exec rm -r {} \;
 find . -type d -name sample -exec rm -r {} \;
 find . -type d -iname benchmark* -exec rm -r {} \;
 find . -type d -iname .nyc_output -exec rm -r {} \;
 find . -type d -iname unpacked -exec rm -r {} \;
 find . -type d -name man* -exec rm -r {} \;
 find . -type d -name tst -exec rm -r {} \;

 find . -type f -name bench.gnu -exec rm {} \;
 find . -type f -name .npmignore -exec rm {} \;
 find . -type f -name .travis.yml -exec rm {} \;
 find . -type f -name .jshintrc -exec rm {} \;
 find . -type f -iname README.md -exec rm {} \;
 find . -type f -iname HISTORY.md -exec rm {} \;
 find . -type f -iname CONTRIBUTING.md -exec rm {} \;
 find . -type f -iname CHANGE*.md -exec rm {} \;
 find . -type f -iname .gitmodules -exec rm {} \;
 find . -type f -iname .gitattributes -exec rm {} \;
 find . -type f -iname .gitignore -exec rm {} \;
 find . -type f -iname "*~" -exec rm {} \;

# slightly more risky
 find . -iname test* -exec rm -r {} \;
 find . -type f -iname usage.txt -exec rm {} \;
 find . -type f -iname example.js -exec rm {} \;
 find . -type d -name node-pre-gyp-github -exec rm -r {} \;
 find . -type f -iname build-all.json -exec rm {} \;
# find . -iname LICENSE* -type f -exec rm {} \;

echo -e "\nTar up the existing install"
rm -rf /tmp/n*
cd /
tar zcf /tmp/nred.tgz /usr/lib/node_modules/node-red* /usr/bin/node-red* /etc/node-red* /etc/init.d/node-red
echo -e " "
ls -l /tmp/nred.tgz
echo -e " "

echo -e "Extract nred.tgz to /tmp directory"
mkdir -p /tmp/nodered_$VER
tar zxf /tmp/nred.tgz -C /tmp/nodered_$VER
cd /tmp/nodered_$VER
echo -e "2.0\n" > debian-binary

echo -e "\nReset file ownerships and permissions"
chown -R root:root *
chmod -R -s *
find . -type f -iname "*.js" -exec chmod 644 {} \;
find . -iname "*.json" -exec chmod 644 {} \;
find . -iname "*.yml" -exec chmod 644 {} \;
find . -iname "*.md" -exec chmod 644 {} \;
find . -iname "*.html" -exec chmod 644 {} \;
find . -iname LICENSE* -exec chmod 644 {} \;
find . -iname Makefile -exec chmod 644 {} \;
find . -iname *.png -exec chmod 644 {} \;
find . -iname *.txt -exec chmod 644 {} \;
find . -iname *.conf -exec chmod 644 {} \;
find . -iname *.pem -exec chmod 644 {} \;
find . -iname *.cpp -exec chmod 644 {} \;
find . -iname *.h -exec chmod 644 {} \;
find . -iname prepublish.sh -exec chmod 644 {} \;
find . -iname update_authors.sh -exec chmod 644 {} \;
find . -type d -exec chmod 755 {} \;
chmod 644 usr/lib/node_modules/node-red/editor/vendor/font-awesome/css/*
chmod 644 usr/lib/node_modules/node-red/editor/vendor/font-awesome/fonts/*
chmod 755 usr/lib/node_modules/node-red/red.js

SIZE=`du -ks . | cut -f 1`
echo -e "Installed size is $SIZE"

echo -e "\nCreate control files"
# cd control
echo -e "Package: node-red" |  tee control
echo -e "Version: $VER" |  tee -a control
echo -e "Section: editors" |  tee -a control
echo -e "Priority: optional" |  tee -a control
# echo -e "Architecture: x86_64" |  tee -a control
echo -e "Architecture: all" |  tee -a control
echo -e "License: Apache 2.0" | tee -a control
echo -e "Installed-Size: $SIZE" |  tee -a control
echo -e "Depends: node-npm" |  tee -a control
echo -e "Homepage: http://nodered.org" |  tee -a control
echo -e "Maintainer: Dave Conway-Jones <dceejay@gmail.com>" |  tee -a control
echo -e "Description: Node-RED application flow editor" |  tee -a control
echo -e " See http://nodered.org for more information, documentation and examples." |  tee -a control
echo -e " Copyright 2017,2018 JS Foundation and other contributors, https://js.foundation/" |  tee -a control
echo -e " Copyright 2015,2017 IBM Corp." |  tee -a control

echo -e "/etc/node-red/package.json" | tee conffiles
echo -e "/etc/node-red/settings.js" | tee -a conffiles
echo -e "/etc/node-red/.config.json" | tee -a conffiles
echo -e "/etc/node-red/flows.json" | tee -a conffiles
echo -e "/etc/node-red/flows_cred.json" | tee -a conffiles

echo -e "/etc/init.d/node-red stop" |  tee prerm
echo -e "exit 0" |  tee -a prerm
# echo -e "npm i -g npm >/dev/null 2>&1; exit 0" |  tee postinst
echo -e "/etc/init.d/node-red enable" |  tee postinst
echo -e "/etc/init.d/node-red start" |  tee -a postinst
echo -e "exit 0" |  tee -a postinst
chmod 0755 postinst prerm

# Create the ipk file
echo -e "\nBuild the actual ipk file"
cd /tmp/nodered_$VER/
tar cvf "control.tar" "./control" "./conffiles" "./postinst" "./prerm"
# gzip < "control.tar" > "control.tar.gz"
gzip "control.tar"
tar cvf data.tar usr* etc*
# gzip < "data.tar" > "data.tar.gz"
gzip "data.tar"
tar cf "/tmp/packagetemp.tar" "./control.tar.gz" "./data.tar.gz" "./debian-binary"
gzip < "/tmp/packagetemp.tar" > "/tmp/node-red_$VER.ipk"

echo -e " "
ls -lart /tmp/*.ipk
echo -e " "
