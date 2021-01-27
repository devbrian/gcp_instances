#! /bin/bash
cd /opt/
wget https://nzbget.net/download/nzbget-latest-bin-linux.run
sh nzbget-latest-bin-linux.run
rm nzbget-latest-bin-linux.run

rm /opt/nzbget/nzbget.conf
mv /tmp/nzbget.conf /opt/nzbget/nzbget.conf
chmod 777 /opt/nzbget/nzbget.conf

curl https://rclone.org/install.sh | sudo bash

systemctl enable nzbget.service
systemctl start nzbget.service
