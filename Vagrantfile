# -*- mode: ruby -*-
# vi: set ft=ruby :
# export VAGRANT_EXPERIMENTAL="disks"

Vagrant.configure("2") do |config|

  config.vm.box = 'almalinux/8'

  config.vm.define "server" do |server|

    server.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    server.vm.disk :disk, size: "1GB", name: "disk1"
    server.vm.disk :disk, size: "1GB", name: "disk2"
    server.vm.disk :disk, size: "1GB", name: "disk3"
    server.vm.host_name = 'server'
#    server.vm.network :private_network, ip: "192.168.56.11"
    server.vm.provision "shell", name: "Setup zfs", path: "setup_zfs.sh"
  end


# Cent OS 8.2
# config used from this
# https://github.com/eoli3n/vagrant-pxe/blob/master/client/Vagrantfile
  config.vm.define "client" do |client|
    client.vm.host_name = 'client'
#    client.vm.network :private_network, ip: "192.168.56.12"
    client.vm.disk :disk, size: "1GB", name: "disk1"
    client.vm.disk :disk, size: "1GB", name: "disk2"
    client.vm.disk :disk, size: "1GB", name: "disk3"
    client.vm.provider :virtualbox do |vb|
      vb.memory = "1024"
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  end

end
