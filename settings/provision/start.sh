#!/bin/bash
sudo systemctl start elasticsearch
sudo service elasticsearch status 

#set up nginx server
sudo cp /vagrant/settings/nginx/magento.conf /etc/nginx/sites-available/magento.conf
sudo chmod 644 /etc/nginx/sites-available/magento.conf
sudo ln -s /etc/nginx/sites-available/magento.conf /etc/nginx/sites-enabled/magento.conf

rm -rf /etc/nginx/sites-available/default   
rm -rf /etc/nginx/sites-enabled/default

sudo cp /vagrant/settings/nginx/nginx.conf /etc/nginx/sites-available/default.conf
sudo chmod 644 /etc/nginx/sites-available/default.conf
sudo ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf




sudo service nginx restart
sudo nginx -t