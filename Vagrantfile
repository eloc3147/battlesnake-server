# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.provider "virtualbox" do |v|
    v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end

  config.vm.network "forwarded_port", guest: 3000, host: 3000

  config.vm.provision "shell", path: 'scripts/build-langs.sh', keep_color: true
  config.vm.provision "shell", path: 'scripts/provision.sh', keep_color: true, privileged: false
end
