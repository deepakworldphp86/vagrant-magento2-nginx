#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
           
# update

sudo apt-get update
sudo apt-get -y upgrade

# Install required command software
sudo apt-get -y install software-properties-common
sudo apt-get update
sudo apt-get -y install expect zip unzip


# Install curl software
if !  [ -x "$(command which curl)" ]; then

sudo apt-get -y install curl 
else
    
     echo "Curl already installed."

fi

# Install git 
if !  [ -x "$(command which git)" ]; then
sudo apt-get -y install curl git
else
    
     echo "Git already installed."

fi

# Install nginx software

if !  [ -x "$(command which nginx)" ]; then
    sudo apt-get -y install nginx
    sudo service nginx start
    sudo service nginx status
    sudo ufw allow OpenSSH
    sudo ufw allow 'Nginx HTTP'
    sudo ufw enable
    sudo ufw status
    sudo service nginx reload
else
    
     echo "Nginx already installed."

fi


# PHP install
if !  [ -x "$(command which php)" ]; then
    sudo apt-get  install -y php7.2-common php7.2-cli php7.2-fpm php7.2-opcache php7.2-gd php7.2-mysql php7.2-curl 
    php7.2-intl php7.2-xsl php7.2-mbstring php7.2-zip php7.2-bcmath php7.2-soap
    systemctl status php7.2-fpm
else
    
     echo "PHP already installed."

fi

# Maria DB install
if !  [ -x "$(command which mysql)" ]; then
  sudo apt-get install -y mariadb-server mariadb-client
  sudo systemctl stop mariadb.service
  sudo systemctl start mariadb.service
  sudo systemctl enable mariadb.service
  sudo systemctl status mariadb
else
   echo "Mysql already installed."
fi


# Composer 
if  [ -x "$(command which composer)" ]; then
     sudo curl -sS https://getcomposer.org/installer | sudo php -dmemory_limit=-1 -- --install-dir=/usr/local/bin --filename=composer
     composer -V
else
    
     echo "Composer already installed."
fi


#***********************************Mysql secure instalation************************#
  
MYSQL=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $11}')

 MYSQL_PASS=admin123

expect -f - <<-EOF
  set timeout 10
  spawn mysql_secure_installation
  expect "Enter current password for root (enter for none):"
  send -- "\r"
  expect "Set root password?"
  send -- "y\r"
  expect "New password:"
  send -- "${MYSQL_PASS}\r"
  expect "Re-enter new password:"
  send -- "${MYSQL_PASS}\r"
  expect "Remove anonymous users?"
  send -- "y\r"
  expect "Disallow root login remotely?"
  send -- "y\r"
  expect "Remove test database and access to it?"
  send -- "y\r"
  expect "Reload privilege tables now?"
  send -- "y\r"
  expect eof
EOF




#****************Create Database && DB import*********************#
# create random password
PASSWDDB="$(openssl rand -base64 12)"

# replace "-" with "_" for database username
MAINDB=${USER_NAME//[^a-zA-Z0-9]/_}

mysql -u root -p<<MYSQL_SCRIPT
CREATE DATABASE $MAINDB;

CREATE DATABASE ${MAINDB} /*\!40100 DEFAULT CHARACTER SET utf8 */;
CREATE USER ${MAINDB}@localhost IDENTIFIED BY '${PASSWDDB}';
GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${MAINDB}'@'localhost';
FLUSH PRIVILEGES;




#*****************End database create and DB import **************#

#****************Magento install by composer*********************#

#cat << EOF > /etc/nginx/sites-available/nginx.conf
#    server {
#
#         listen 80;
#         server_name  citymedrx.vg.com;
#         access_log /var/log/nginx/access.log;
#         error_log /var/log/nginx/error.log;
#
#         set $MAGE_ROOT /var/www/html/citymedrx.vg.com;
#         include /var/www/html/citymedrx.vg.com/nginx.conf.sample;
#     }
#EOF
#sudo chmod 644 /etc/nginx/sites-available/nginx.conf
#sudo ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf
#sudo service nginx restart
#fi

#****************End*********************#

# set up nginx server
sudo cp /vagrant/settings/nginx/nginx.conf /etc/nginx/sites-available/site.conf
sudo chmod 644 /etc/nginx/sites-available/site.conf
sudo ln -s /etc/nginx/sites-available/site.conf /etc/nginx/sites-enabled/site.conf
sudo service nginx restart

# clean /var/www
sudo rm -Rf /var/www

# symlink /var/www => /vagrant
ln -s /vagrant /var/www
