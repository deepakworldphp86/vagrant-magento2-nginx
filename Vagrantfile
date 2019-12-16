# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    # /*=====================================
    # =            FREE VERSION!            =
    # =====================================*/
    # This is the free (still awesome) version of Scotch Box.
    # Please go Pro to support the project and get more features.
    # Check out https://box.scotch.io to learn more. Thanks

    config.vm.box = "ubuntu/bionic64"
    config.vm.network "private_network", ip: "192.168.33.20"
    config.vm.hostname = "magento2.vg.com"
    config.vm.synced_folder ".", "/var/www", :mount_options => ["dmode=777", "fmode=666"]
    config.vm.provision :shell, :path => "settings/provision/bootstrap.sh"
    # Optional NFS. Make sure to remove other synced_folder line too
    #config.vm.synced_folder ".", "/var/www", :nfs => { :mount_options => ["dmode=777","fmode=666"] }

end