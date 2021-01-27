#! /bin/bash
cd /opt/

wget https://nzbget.net/download/nzbget-latest-bin-linux.run
sh nzbget-latest-bin-linux.run
rm nzbget-latest-bin-linux.run
rm /opt/nzbget/nzbget.conf
mv /tmp/nzbget.conf /opt/nzbget/nzbget.conf
chmod 777 /opt/nzbget/nzbget.conf

curl https://rclone.org/install.sh | sudo bash
mkdir --parents /root/.config/rclone/
mv /tmp/rclone.conf /root/.config/rclone/rclone.conf

git clone https://github.com/l3uddz/cloudplow /opt/cloudplow
apt-get install python3-pip
cd /opt/cloudplow
python3 -m pip install -r requirements.txt
ln -s /opt/cloudplow/cloudplow.py /usr/local/bin/cloudplow
mv /tmp/config.json /opt/cloudplow/config.json

mkdir /root/keys

systemctl enable nzbget.service
systemctl start nzbget.service

systemctl enable cloudplow.service
systemctl start cloudplow.service
