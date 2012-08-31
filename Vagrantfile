# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant/action/vm/share_folders'
module Vagrant
  module Action
    module VM
      class ShareFolders
        def create_metadata
          @env[:ui].info I18n.t("vagrant.actions.vm.share_folders.creating")

          folders = []
          shared_folders.each do |name, data|
            folders << {
              :name => name,
              :hostpath => File.expand_path(data[:hostpath], @env[:root_path]),
              :transient => data[:transient],
              :readonly => data[:readonly]
            }
          end

          @env[:vm].driver.share_folders(folders)
        end
      end
    end
  end
end

require 'vagrant/driver/virtualbox_4_1'
module Vagrant
  module Driver
    class VirtualBox_4_1
      def share_folders(folders)
        folders.each do |folder|
          args = ["--name",
                  folder[:name],
                  "--hostpath",
                  folder[:hostpath]]
          args << "--transient" if folder.has_key?(:transient) && folder[:transient]
          args << "--readonly" if folder.has_key?(:readonly) && folder[:readonly]
          execute("sharedfolder", "add", @uuid, *args)
        end
      end
    end
  end
end

Vagrant::Config.run do |config|
  config.vm.define :www do |www|
    www.vm.box = "precise32"
    www.vm.host_name = "www"

    www.vm.forward_port 4000, 4000

    unless RUBY_PLATFORM.match(/mingw32/)
      happy_numbers = [1, 7, 10, 13, 19, 23, 28, 31, 32, 44, 49, 68, 70, 79, 82, 86, 91, 94, 97, 100, 103, 109, 129, 130, 133, 139, 167, 176, 188, 190, 192, 193, 203, 208, 219, 226, 230, 236, 239]
      random_octet = ((0..255).to_a - happy_numbers).sample
      www.vm.network :hostonly, "192.168.#{random_octet}.3"
      www.vm.share_folder "v-root", "/vagrant", ".", :nfs => true
    end

    www.vm.share_folder "dot-ssh", "/home/vagrant/dot-ssh", "~/.ssh", :readonly => true

    www.vm.provision :puppet do |puppet|
      puppet.manifests_path = "_manifests"
      puppet.manifest_file  = "www.pp"
    end
  end
end
