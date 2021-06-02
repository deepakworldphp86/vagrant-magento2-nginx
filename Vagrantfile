# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.provider "virtualbox" do |v|
        v.memory = 4096
        v.cpus = 2
    end

    config.vm.box = "ubuntu/focal64"
    config.vm.network "private_network", ip: "192.168.50.4"
    config.vm.hostname = "magento2.vg.com"
    config.vm.hostname = "mage2.local.com"
    
    config.vm.synced_folder "public/", "/var/www/html",disabled: false, :mount_options => ["dmode=777", "fmode=666"]
    config.vm.provision :shell, :path => "settings/provision/bootstrap.sh"
    config.vm.provision :shell, :path => "settings/provision/start.sh", run: 'always'

    
    config.vm.provision "file", source: "settings/nginx/nginx.conf", destination: "/tmp/nginx.conf"
    config.vm.provision "file", source: "settings/nginx/magento.conf", destination: "/tmp/magento.conf"

    config.vm.provision "shell",inline: "rm -rf /etc/nginx/sites-available/default   /etc/nginx/sites-enabled/default "
    config.vm.provision "shell",inline: "mv /tmp/nginx.conf /etc/nginx/sites-available/nginx.conf"
    config.vm.provision "shell",inline: "mv /tmp/magento.conf /etc/nginx/sites-available/magento.conf"

    config.vm.provision "shell",inline: "sudo ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf"
    config.vm.provision "shell",inline: "sudo ln -s /etc/nginx/sites-available/magento.conf /etc/nginx/sites-enabled/magento.conf"

    config.vm.provision "shell",inline: "sudo service nginx restart"
    #config.vm.provision "shell",inline: "tput setaf 3;echo Testing start"
    config.vm.provision "shell",inline: "sudo nginx -t"
    config.vm.provision "shell",inline: "sudo systemctl start elasticsearch"
    config.vm.provision "shell",inline: "sudo service elasticsearch status"

end
