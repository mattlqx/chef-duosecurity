if node['duosecurity']['use_duo_repo']
  include_recipe 'apt'

  platform = node['platform'].capitalize
  codename = node['lsb']['codename'] == 'utopic' ? 'trusty' : node['lsb']['codename']

  apt_repository 'duosecurity' do
    uri "http://pkg.duosecurity.com/#{platform}"
    components ['main']
    distribution codename
    key 'https://duo.com/APT-GPG-KEY-DUO'
    action :add
  end

  %w[
    login-duo
    libpam-duo
  ].each do |pkg|
    package pkg do
      action :purge
    end
  end

  package 'duo-unix' do
    action node['duosecurity']['package_action'].to_sym
  end
else
  package 'duo-unix' do
    action :purge
  end

  pkgs = ['login-duo']
  pkgs << 'libpam-duo' if node['duosecurity']['use_pam'] == 'yes'

  pkgs.each do |pkg|
    package pkg do
      action node['duosecurity']['package_action'].to_sym
    end
  end
end
