# Install login_duo
# https://www.duosecurity.com/docs/duounix#1.-set-up-login_duo
ark "duosecurity" do
  url "https://dl.duosecurity.com/duo_unix-#{node['duosecurity']['source_version']}.tar.gz"
  autoconf_opts ["--prefix=/usr"]
  checksum node['duosecurity']['source_sha256']
  action :install_with_make
end
