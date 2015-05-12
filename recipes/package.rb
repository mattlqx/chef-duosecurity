package 'login-duo' do
  action node['duosecurity']['package_action'].to_sym
end
