#! /bin/bash

mkfs.ext4 -F /dev/nvme0n1
mkdir /mnt/unionfs/
mount /dev/nvme0n1 /mnt/unionfs/
chmod 777 /mnt/unionfs/

apt-get update
cd /opt/

wget https://nzbget.net/download/nzbget-latest-bin-linux.run
sh nzbget-latest-bin-linux.run
rm nzbget-latest-bin-linux.run
rm /opt/nzbget/nzbget.conf
mv /tmp/nzbget.conf /opt/nzbget/nzbget.conf
chmod 777 /opt/nzbget/nzbget.conf

cd /opt/nzbget/scripts
wget https://raw.githubusercontent.com/clinton-hall/GetScripts/master/flatten.py
wget https://raw.githubusercontent.com/clinton-hall/GetScripts/master/DeleteSamples.py
wget https://raw.githubusercontent.com/Prinz23/nzbget-pp-reverse/master/reverse_name.py
wget https://raw.githubusercontent.com/l3uddz/nzbgetScripts/master/HashRenamer.py
chmod 777 *

curl https://rclone.org/install.sh | sudo bash
mkdir --parents /root/.config/rclone/
mv /tmp/rclone.conf /root/.config/rclone/rclone.conf

git clone https://github.com/l3uddz/cloudplow /opt/cloudplow
apt-get install -y python3-pip unzip 
cd /opt/cloudplow
python3 -m pip install -r requirements.txt
ln -s /opt/cloudplow/cloudplow.py /usr/local/bin/cloudplow
mv /tmp/config.json /opt/cloudplow/config.json

mkdir /root/keys
cd /root/keys
rclone copy google:/Backups/keys.zip /root/keys/
unzip keys.zip
rm keys.zip

systemctl enable nzbget.service
systemctl start nzbget.service

systemctl enable cloudplow.service
systemctl start cloudplow.service
