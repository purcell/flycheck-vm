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

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

use_inline_resources

action :install do
  if @current_resource.version.nil?
    converge_by("install package #{@new_resource} #{new_resource.version}") do
       Chef::Log.info("Installing #{@new_resource.name} #{new_resource.version}")
       install_package(@new_resource.name, @new_resource.version)
    end
  elsif @current_resource.version != @new_resource.version
    description = "install package #{@new_resource} #{@current_resource.version} -> #{@new_resource.version}"
    converge_by(description) do
      Chef::Log.info("Moving #{@new_resource.name} from #{@current_resource.version} to #{new_resource.version}")
      remove_package(@new_resource.name)
      install_package(@new_resource.name, @new_resource.version)
    end
  end
end

action :uninstall do
  if !@current_resource.version.nil?
    desc = "uninstall package #{@new_resource} #{@current_resource.version}"
    converge_by(desc) do
      Chef::Log.info("Removing #{@new_resource.name}")
      remove_package(@new_resource.name)
    end
  end
end

action :upgrade do
  if @current_resource.version.nil?
    converge_by("install package #{@new_resource} #{new_resource.version}") do
      Chef::Log.info("Installing #{@new_resource.name} #{new_resource.version}")
      install_package(@new_resource.package_name, @new_resource.version)
    end
  else
    latest_version = get_available_versions(@new_resource.package_name).first
    if @current_resource.version != latest_version
      description = "upgrade package #{@new_resource} #{@current_resource.version} -> #{latest_version}"
      converge_by(description) do
        Chef::Log.info("Upgrading #{@new_resource.name} from #{@current_resource.version} to #{latest_version}")
        remove_package(@new_resource.name)
        install_package(@new_resource.name, nil)
      end
    end
  end
end

def load_current_resource
  @bin = node['lua']['luarocks']
  @current_resource = Chef::Resource::LuaRocks.new(@new_resource.name)
  @current_resource.package_name(@new_resource.package_name)
  @current_resource.version(
    get_installed_version(@new_resource.package_name))
end

def get_installed_version(name)
  result = shell_out!("#{@bin} list")
  version_line = result.stdout
                 .each_line
                 .drop_while { |line| line.strip != name }
                 .drop(1)
                 .first
  version_line.strip.split(/\s/).first if !version_line.nil?
end

def get_available_versions(name)
  result = shell_out!("#{@bin} search #{name}")
  version_lines = result.stdout
                  .each_line
                  .drop_while { |line| line.strip != name }
                  .drop(1)
                  .take_while { |line| !line.strip.empty? }
  version_lines
    .map { |line| line.strip.split(/\s/).first }
    .uniq
end

def install_package(name, version)
  cmd = "#{@bin} install #{name}"
  if !version.nil?
    cmd << " #{version}"
  end
  shell_out!(cmd)
end

def remove_package(name)
  shell_out!("#{@bin} remove #{name}")
end
