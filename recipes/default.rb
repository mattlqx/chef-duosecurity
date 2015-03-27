duo_creds = Chef::EncryptedDataBagItem.load("credentials", "duosecurity")

integration_key = duo_creds["integration_key"]
secret_key = duo_creds["secret_key"]
api_hostname = duo_creds["api_hostname"]

# Install login_duo
# https://www.duosecurity.com/docs/duounix#1.-set-up-login_duo
ark "duosecurity" do
  url "https://dl.duosecurity.com/duo_unix-latest.tar.gz"
  autoconf_opts ["--prefix=/usr"]
  checksum "415cf02981f66ba9447df81e2fcf41e004220126640cc5f667720d46c431abf9"
  action :install_with_make
end

# Config
# https://www.duosecurity.com/docs/duounix#configuration-options
template "/etc/duo/login_duo.conf" do
  source "login_duo.conf.erb"
  sensitive true
  variables(
   integration_key: integration_key,
   secret_key: secret_key,
   api_hostname: api_hostname
  )
end

# Enable login_duo and harden sshd
# https://www.duosecurity.com/docs/duounix#3.-enable-login_duo
sshd_directives = [
  "ForceCommand /usr/sbin/login_duo",
  "PermitTunnel no",
  "AllowTcpForwarding no"
]

sshd_directives.each do |directive|
  ruby_block "enable_login_duo_for_ssh" do
    block do
      fe = Chef::Util::FileEdit.new("/etc/ssh/sshd_config")
      fe.insert_line_if_no_match(/#{directive}/, directive)
      fe.write_file
    end
  end
end

