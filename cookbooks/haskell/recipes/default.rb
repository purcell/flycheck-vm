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

apt_repository 'hvr-ghc' do
  uri          'ppa:hvr/ghc'
  distribution node['lsb']['codename']
end

['ghc', 'cabal', 'alex', 'happy'].each do |program|
  version = node['haskell'][program]['version']
  package = program == 'cabal' ? 'cabal-install' : program

  package "#{package}-#{version}" do
    action :upgrade
    options '--no-install-recommends'
  end

  file "/etc/profile.d/#{program}.sh" do
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    content <<END
export PATH="/opt/#{program}/#{version}/bin:$PATH"
END
  end
end
