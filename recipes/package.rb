# frozen_string_literal: true

require 'mixlib/shellout'

if node['duosecurity']['package_file']
  dpkg_package 'duo-unix' do
    source node['duosecurity']['package_file']
    action node['duosecurity']['package_action'].to_sym
  end
elsif node['duosecurity']['use_duo_repo']
  platform = node['platform'].capitalize
  codename = node['lsb']['codename']

  # Determine if key is expired
  expired = shell_out("apt-key list --list-keys 'Duo Security Package Signing' | grep expired") \
            .exitstatus.zero?

  execute 'remove expired duo repo key' do
    command 'apt-key del "30BF E024 2B19 592E B122  211D 1CC9 1FC6 15D3 2EFC"; apt-key del 15D32EFC'
    only_if { expired }
  end

  apt_repository 'duosecurity' do
    uri "http://pkg.duosecurity.com/#{platform}"
    arch 'amd64' if codename == 'bionic'
    components ['main']
    distribution codename
    key 'https://duo.com/DUO-GPG-PUBLIC-KEY.asc'
    action expired ? %i[remove add] : :add
  end

  apt_update 'duo' do
    action :periodic
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
