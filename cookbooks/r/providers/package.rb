# coding: utf-8
# Copyright (c) 2015  Sebastian Wiesner <swiesner@lunaryorn.com>

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
  unless @current_resource
    expr = "install.packages(c(\"#{new_resource.name}\"))"
    shell_out!('Rscript', '-e', expr)
    Chef::Log.info("#{@new_resource} installed #{@new_resource.name}")
  end
end

action :uninstall do
  if @current_resource
    converge_by("install package #{@new_resource}") do
      expr = "remove.packages(c(\"#{new_resource.name}\"))"
      shell_out!('Rscript', '-e', expr)
      Chef::Log.info("#{@new_resource} uninstalled #{@new_resource.name}")
    end
  end
end

def load_current_resource
  @bin = 'Rscript'
  resource = Chef::Resource.resource_for_node(:r_package, node)
  version = get_installed_version(@new_resource.package_name)
  return unless version

  @current_resource = resource.new(@new_resource.name)
  @current_resource.package_name(@new_resource.package_name)
end

def get_installed_version(name)
  options = {
    environment: {
      'LC_ALL' => 'C',
      'LANG' => 'C',
      'LANGUAGE' => 'C'
    }
  }
  result = shell_out('Rscript', '-e', "packageVersion(\"#{name}\")", options)
  /\[1\] '(?<version>.+)'/ =~ result.stdout.strip && version
end
