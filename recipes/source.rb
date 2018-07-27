# Install login_duo
# https://www.duosecurity.com/docs/duounix#1.-set-up-login_duo

include_recipe 'build-essential'

configure_opts = ['--prefix=/usr']

if node['duosecurity']['use_pam'] == 'yes'
  package 'libpam-dev' do
    action :install
  end
  configure_opts << '--with-pam=/lib64/security'
end

ark 'duosecurity' do
  url "https://dl.duosecurity.com/duo_unix-#{node['duosecurity']['source_version']}.tar.gz"
  autoconf_opts configure_opts
  checksum node['duosecurity']['source_sha256']
  action :install_with_make
end
