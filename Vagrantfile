# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.define :wwww do |www|
    www.vm.box = "precise32"
    www.vm.host_name = "www"

    www.vm.forward_port 4000, 4000

    www.vm.provision :puppet do |puppet|
      puppet.manifests_path = "_manifests"
      puppet.manifest_file  = "www.pp"
    end
  end
end
