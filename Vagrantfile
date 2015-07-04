# -*- mode: ruby -*-
# Copyright (c) 2015 Sebastian Wiesner <swiesner@lunaryorn.com>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

BASEDIR = Pathname.new(__FILE__).dirname
FLYCHECK_CANDIDATES = [BASEDIR.join('flycheck'),
                       BASEDIR.parent.join('flycheck')]
FLYCHECK = FLYCHECK_CANDIDATES.each.find(&:directory?)

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.host_name = 'flycheck-test'
  config.vm.synced_folder '.', '/flycheck'

  config.vm.provider 'virtualbox' do |vb|
    vb.name = 'Flycheck VM'
    vb.memory = 1024
  end

  if FLYCHECK
    config.vm.synced_folder FLYCHECK, '/home/vagrant/flycheck',
                            type: 'rsync',
                            rsync__exclude: ['.git/', '.cask/', '.#*']
  end

  config.berkshelf.enabled = true

  config.vm.provision 'chef_zero' do |chef|
    chef.roles_path = ['roles']

    roles = ENV['CHEF_ROLES']
    roles = roles ? roles.split(',') : ['flycheck']
    roles.each do |role|
      chef.add_role role
    end
  end
end
