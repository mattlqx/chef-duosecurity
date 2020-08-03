default['duosecurity']['install_type'] = 'source'
default['duosecurity']['package_action'] = 'upgrade'
default['duosecurity']['package_file'] = nil
default['duosecurity']['source_sha256'] = '4fdb1a11473e167b7c062bd366807b9c436192a16b25031f2cb6e72f8da313c3'
default['duosecurity']['source_version'] = '1.11.4'
default['duosecurity']['use_pam'] = 'no'
default['duosecurity']['pam_directory'] = "/lib/#{node['kernel']['machine']}-linux-gnu/security"
default['duosecurity']['protect_sudo'] = 'no'
default['duosecurity']['use_duo_repo'] = 'no'

default['duosecurity']['apt']['keyserver'] = 'pgp.mit.edu'
