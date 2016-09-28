#!/bin/bash -v

## Install MongoDB Ubuntu 14.04
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org


## Install package dependencies
sudo apt-get install -y git nodejs-legacy npm supervisor nginx 

## Fetch software, configure and install
cd /opt
git clone git://github.com/opinsys/walma.git
cd walma
git checkout f6fb11d47feaa1597cfd1aacbf8d09aeaff3f769
npm install
bin/setupdb

## Strip out the google analytics they left in the source code
sed -i '/<script type="text\/javascript"/,/<\/script>/d' views/index.jade
sed -i '/<script type="text\/javascript"/,/<\/script>/d' views/layout.jade

# Setup supervisord to keep the service running
cat << EOT >> /etc/supervisor/conf.d/walma.conf
[program:walma]
directory=/opt/walma
command=npm start
user=ubuntu
autostart=true
autorestart=true
stderr_logfile=/var/log/walma.err.log
stdout_logfile=/var/log/walma.out.log
EOT

## Run Walma
service supervisor restart


# Setup nginx to only do proxy pass
cat << EOT > /etc/nginx/sites-available/default
server {
  listen 80;
  location / {
    proxy_pass http://127.0.0.1:1337;
    proxy_set_header Host \$host;
    proxy_http_version 1.1;
    proxy_read_timeout 1d;
 }
}
EOT

# Restart nginx and everything should be ready!
service nginx restart



