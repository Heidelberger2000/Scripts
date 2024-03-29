#!/bin/bash

# Quelle:  https://community.home-assistant.io/t/autostart-esphome-dashboard/117530/18

apt-get update
apt-get -y upgrade
apt install wget python3-pip python3-venv
useradd --home-dir=/opt/esphome --create-home esphome
# su - esphome
python3 -m venv venv
source venv/bin/activate
pip install esphome
pip install pillow

echo "#!/bin/bash

source venv/bin/activate
esphome dashboard /opt/esphome/config/" >> /opt/esphome/start.sh

chmod +x /opt/esphome/start.sh

echo "[Unit]
Description=ESPHome Dashboard Service
After=network.target

[Service]
Type=simple
User=esphome
WorkingDirectory=/opt/esphome
ExecStart=/opt/esphome/start.sh
RestartSec=30
Restart=on-failure

[Install]
WantedBy=multi-user.target" >> /lib/systemd/system/esphomedashboard.service

cd ~
wget https://raw.githubusercontent.com/Heidelberger2000/Scripts/main/Linux/ESPHome/ESPHome.sh
cp ESPHome.sh /etc/cron.daily/ESPHome.sh

chmox +x /etc/cron.daily/ESPHome.sh

systemctl daemon-reload
systemctl start esphomedashboard.service
systemctl enable esphomedashboard.service
