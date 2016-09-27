#!/bin/bash -v

## Install MongoDB Ubuntu 14.04
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org


## Install package dependencies
sudo apt-get install git nodejs-legacy npm supervisor -y

## Fetch software, configure and install
cd /opt
git clone git://github.com/opinsys/walma.git
cd walma
git checkout f6fb11d47feaa1597cfd1aacbf8d09aeaff3f769
npm install
bin/setupdb
sed -i 's/"listenPort": 1337/"listenPort": 80/' config.json

# Setup supervisord to keep the service running
cat << EOT >> /etc/supervisor/conf.d/walma.conf
[program:walma]
directory=/opt/walma
command=npm start
autostart=true
autorestart=true
stderr_logfile=/var/log/walma.err.log
stdout_logfile=/var/log/walma.out.log
EOT

## Run
service supervisor restart
