#!/bin/bash
sudo service elasticsearch status 

#set up nginx server
sudo cp /vagrant/settings/nginx/magento.conf /etc/nginx/sites-available/magento.conf
sudo chmod 644 /etc/nginx/sites-available/magento.conf
sudo ln -s /etc/nginx/sites-available/magento.conf /etc/nginx/sites-enabled/magento.conf
sudo service nginx restart
sudo nginx -t