package 'login-duo' do
  action node['duosecurity']['package_action'].to_sym
end

if node['duosecurity']['use_duo_repo']
  platform = node['platform'].capitalize

  apt_repository 'duosecurity' do
    uri "http://pkg.duosecurity.com/#{platform}"
    components ['main']
    distribution node['lsb']['codename']
    key '15D32EFC'
    keyserver 'pgp.mit.edu'
    action :add
  end
end
