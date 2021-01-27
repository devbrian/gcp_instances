#! /bin/bash
cd /opt/
wget https://nzbget.net/download/nzbget-latest-bin-linux.run
sh nzbget-latest-bin-linux.run
rm nzbget-latest-bin-linux.run

sed -i "s/^\(Server1\.Username\s*=\s*\).*\$/\1$s1user/" /tmp/nzbget.conf
sed -i "s/^\(Server1\.Password\s*=\s*\).*\$/\1$s1pass/" /tmp/nzbget.conf
sed -i "s/^\(ControlUsername\s*=\s*\).*\$/\1$user/" /tmp/nzbget.conf
sed -i "s/^\(ControlPassword\s*=\s*\).*\$/\1$pass/" /tmp/nzbget.conf

rm /opt/nzbget/nzbget.conf
mv /tmp/nzbget.conf /opt/nzbget/nzbget.conf
chmod 777 /opt/nzbget/nzbget.conf
