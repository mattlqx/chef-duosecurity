# Required attributes
integration_key     = node["duosecurity"]["integration_key"]
secret_key          = node["duosecurity"]["secret_key"]
api_hostname        = node["duosecurity"]["api_hostname"]

# Optional attributes
groups              = node["duosecurity"]["groups"] if node["duosecurity"]["groups"]
failmode            = node["duosecurity"]["failmode"] if node["duosecurity"]["failmode"]
pushinfo            = node["duosecurity"]["pushinfo"] if node["duosecurity"]["pushinfo"]
http_proxy          = node["duosecurity"]["http_proxy"] if node["duosecurity"]["http_proxy"]
autopush            = node["duosecurity"]["autopush"] if node["duosecurity"]["autopush"]
motd                = node["duosecurity"]["motd"] if node["duosecurity"]["motd"]
prompts             = node["duosecurity"]["prompts"] if node["duosecurity"]["prompts"]
accept_env_factor   = node["duosecurity"]["accept_env_factor"] if node["duosecurity"]["accept_env_factor"]
fallback_local_ip   = node["duosecurity"]["fallback_local_ip"] if node["duosecurity"]["fallback_local_ip"]
https_timeout       = node["duosecurity"]["https_timeout"] if node["duosecurity"]["https_timeout"]

# Install login_duo
# https://www.duosecurity.com/docs/duounix#1.-set-up-login_duo
ark "duosecurity" do
  url "https://dl.duosecurity.com/duo_unix-latest.tar.gz"
  autoconf_opts ["--prefix=/usr"]
  checksum "415cf02981f66ba9447df81e2fcf41e004220126640cc5f667720d46c431abf9"
  action :install_with_make
end

# Config
directory "/etc/duo" do
  mode "0755"
  owner "root"
  group "root"
end

# https://www.duosecurity.com/docs/duounix#configuration-options
template "/etc/duo/login_duo.conf" do
  mode "0400"
  owner "root"
  group "root"
  source "login_duo.conf.erb"
  sensitive true
  variables(
    integration_key: integration_key,
    secret_key: secret_key,
    api_hostname: api_hostname,
    groups: groups,
    failmode: failmode,
    pushinfo: pushinfo,
    http_proxy: http_proxy,
    autopush: autopush,
    motd: motd,
    prompts: prompts,
    accept_env_factor: accept_env_factor,
    fallback_local_ip: fallback_local_ip,
    https_timeout: https_timeout
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

