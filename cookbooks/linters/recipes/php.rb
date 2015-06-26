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

include_recipe 'php'

# Required to build PHPMD
package 'imagemagick' do
  action :upgrade
end

# A dependency of PHPMD
php_pear_channel 'pear.pdepend.org' do
  action :discover
end

phpmd_channel = php_pear_channel 'pear.phpmd.org' do
  action :discover
end

# Install and upgrade PHP linters
php_pear 'PHP_PMD' do
  channel phpmd_channel.channel_name
  action :install
end

php_pear 'PHP_PMD' do
  channel phpmd_channel.channel_name
  action :upgrade
end

php_pear 'PHP_CodeSniffer' do
  action :install
end

php_pear 'PHP_CodeSniffer' do
  action :upgrade
end
