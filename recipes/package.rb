require 'mixlib/shellout'

if node['duosecurity']['use_duo_repo']
  platform = node['platform'].capitalize
  codename = case node['lsb']['codename']
             when 'utopic'
               'trusty'
             when 'bionic'
               'xenial'
             else
               node['lsb']['codename']
             end

  # Determine if key is expired
  expired = Mixlib::ShellOut.new("apt-key list --list-keys 'Duo Security Package Signing' | grep expired") \
                            .run_command \
                            .exitstatus == 0

  execute 'remove expired duo repo key' do
    command 'apt-key del "30BF E024 2B19 592E B122  211D 1CC9 1FC6 15D3 2EFC"; apt-key del 15D32EFC'
    only_if { expired }
  end

  apt_repository 'duosecurity' do
    uri "http://pkg.duosecurity.com/#{platform}"
    components ['main']
    distribution codename
    key 'https://duo.com/APT-GPG-KEY-DUO'
    action expired ? [:remove, :add] : :add
  end

  include_recipe 'apt'

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
