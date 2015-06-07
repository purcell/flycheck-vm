# -*- mode: ruby -*-

Vagrant.configure('2') do |config|

  config.vm.box = 'ubuntu/trusty64'
  config.vm.host_name = 'flycheck-test'
  config.vm.synced_folder '.', '/flycheck'

  config.vm.provider 'virtualbox' do |vb|
    vb.name = 'Flycheck VM'
    vb.memory = 1024
  end

  config.berkshelf.enabled = true

  config.vm.provision 'chef_zero' do |chef|
    chef.roles_path = ['roles']

    chef.add_role 'base'
  end
end
