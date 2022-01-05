# frozen_string_literal: true

# Required attributes
integration_key     = node['duosecurity']['integration_key']
secret_key          = node['duosecurity']['secret_key']
api_hostname        = node['duosecurity']['api_hostname']

# Optional attributes
groups              = node['duosecurity']['groups'] if node['duosecurity']['groups']
failmode            = node['duosecurity']['failmode'] if node['duosecurity']['failmode']
pushinfo            = node['duosecurity']['pushinfo'] if node['duosecurity']['pushinfo']
http_proxy          = node['duosecurity']['http_proxy'] if node['duosecurity']['http_proxy']
autopush            = node['duosecurity']['autopush'] if node['duosecurity']['autopush']
motd                = node['duosecurity']['motd'] if node['duosecurity']['motd']
prompts             = node['duosecurity']['prompts'] if node['duosecurity']['prompts']
accept_env_factor   = node['duosecurity']['accept_env_factor'] if node['duosecurity']['accept_env_factor']
fallback_local_ip   = node['duosecurity']['fallback_local_ip'] if node['duosecurity']['fallback_local_ip']
https_timeout       = node['duosecurity']['https_timeout'] if node['duosecurity']['https_timeout']
use_pam             = node['duosecurity']['use_pam'] if node['duosecurity']['use_pam']
protect_sudo        = node['duosecurity']['protect_sudo'] if node['duosecurity']['protect_sudo']
first_factor        = node['duosecurity']['first_factor'] if node['duosecurity']['first_factor']

include_recipe "duosecurity::#{node['duosecurity']['install_type']}"

# Config
directory '/etc/duo' do
  mode '0755'
  owner 'root'
  group 'root'
end

# https://www.duosecurity.com/docs/duounix#configuration-options
%w[
  /etc/duo/login_duo.conf
  /etc/duo/pam_duo.conf
].each do |config|
  template config do
    mode '0400'
    owner 'root'
    group 'root'
    source 'login_duo.conf.erb'
    sensitive true
    variables ({
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
      https_timeout: https_timeout,
      use_pam: use_pam
    })
  end
end

if use_pam == 'yes'
  node.default['pam_d']['services']['common-auth'] = {
    'main' => {
      'pam_unix' => {
        'interface' => 'auth',
        'control_flag' => 'requisite',
        'name' => 'pam_unix.so',
        'args' => 'nullok_secure'
      },
      'pam_duo' => {
        'interface' => 'auth',
        'control_flag' => '[success=1 default=ignore]',
        'name' => '/lib64/security/pam_duo.so'
      },
      'pam_deny' => {
        'interface' => 'auth',
        'control_flag' => 'requisite',
        'name' => 'pam_deny.so'
      },
      'pam_permit' => {
        'interface' => 'auth',
        'control_flag' => 'required',
        'name' => 'pam_permit.so'
      },
      'pam_cap' => {
        'interface' => 'auth',
        'control_flag' => 'optional',
        'name' => 'pam_cap.so'
      }
    },
    'includes' => []
  }

  node.default['pam_d']['services']['sshd'] = {
    'main' => {
      'auth' => {
        'interface' => 'auth',
        'control_flag' => 'required',
        'name' => '/lib64/security/pam_duo.so'
      },
      'pam_nologin' => {
        'interface' => 'account',
        'control_flag' => 'required',
        'name' => 'pam_nologin.so'
      },
      'pam_selinux close' => {
        'interface' => 'session',
        'control_flag' => '[success=ok ignore=ignore module_unknown=ignore default=bad]',
        'name' => 'pam_selinux.so',
        'args' => 'close'
      },
      'pam_loginuid' => {
        'interface' => 'session',
        'control_flag' => 'required',
        'name' => 'pam_loginuid.so'
      },
      'pam_keyinit' => {
        'interface' => 'session',
        'control_flag' => 'optional',
        'name' => 'pam_keyinit.so',
        'args' => 'force revoke'
      },
      'include common-session' => {
        'interface' => '@include',
        'name' => 'common-session'
      },
      'pam_motd dynamic' => {
        'interface' => 'session',
        'control_flag' => 'optional',
        'name' => 'pam_motd.so',
        'args' => 'motd=/run/motd.dynamic'
      },
      'pam_motd' => {
        'interface' => 'session',
        'control_flag' => 'optional',
        'name' => 'pam_motd.so',
        'args' => 'noupdate'
      },
      'pam_mail' => {
        'interface' => 'session',
        'control_flag' => 'optional',
        'name' => 'pam_mail.so',
        'args' => 'standard noenv'
      },
      'pam_limits' => {
        'interface' => 'session',
        'control_flag' => 'required',
        'name' => 'pam_limits.so'
      },
      'pam_env' => {
        'interface' => 'session',
        'control_flag' => 'required',
        'name' => 'pam_env.so'
      },
      'pam_env locale' => {
        'interface' => 'session',
        'control_flag' => 'required',
        'name' => 'pam_env.so',
        'args' => 'user_readenv=1 envfile=/etc/default/locale'
      },
      'pam_selinux open' => {
        'interface' => 'session',
        'control_flag' => '[success=ok ignore=ignore module_unknown=ignore default=bad]',
        'name' => 'pam_selinux.so',
        'args' => 'open'
      }
    },
    'includes' => %w[
      common-account
      common-password
    ]
  }

  # When using password instead of pubkey, the only thing different about
  # the above is ssh auth using common-auth instead of pam_duo.so
  if first_factor == 'password'
    node.default['pam_d']['services']['sshd']['main']['auth'] = {
      'interface' => '@include',
      'name' => 'common-auth'
    }
  end

  if protect_sudo == 'yes'
    node.default['pam_d']['services']['sudo'] = {
      'main' => {
        'pam_env' => {
          'interface' => 'auth',
          'control_flag' => 'required',
          'name' => 'pam_env.so',
          'args' => 'readenv=1 user_readenv=0'
        },
        'pam_env locale' => {
          'interface' => 'auth',
          'control_flag' => 'required',
          'name' => 'pam_env.so',
          'args' => 'readenv=1 envfile=/etc/default/locale user_readenv=0'
        },
        'pam_duo' => {
          'interface' => 'auth',
          'control_flag' => 'sufficient',
          'name' => '/lib64/security/pam_duo.so'
        }
      },
      'includes' => %w[
        common-auth
        common-account
        common-session-noninteractive
      ]
    }
  end

  include_recipe 'pam'
end

# Enable login_duo and harden sshd
# https://www.duosecurity.com/docs/duounix#3.-enable-login_duo
node.default['sshd']['sshd_config']['PermitTunnel'] = 'no'
node.default['sshd']['sshd_config']['AllowTcpForwarding'] = 'no'
node.default['sshd']['sshd_config']['UseDNS'] = 'no'

if use_pam == 'yes'
  node.default['sshd']['sshd_config']['UsePAM'] = 'yes'
  node.default['sshd']['sshd_config']['ChallengeResponseAuthentication'] = 'yes'
else
  node.default['sshd']['sshd_config']['ForceCommand'] = '/usr/sbin/login_duo'
end

case first_factor
when 'pubkey'
  node.default['sshd']['sshd_config']['PasswordAuthentication'] = 'no'
  node.default['sshd']['sshd_config']['AuthenticationMethods'] = 'publickey,keyboard-interactive'
  node.default['sshd']['sshd_config']['PubkeyAuthentication'] = 'yes'
  node.default['sshd']['sshd_config']['RSAAuthentication'] = 'yes'
when 'password'
  node.default['sshd']['sshd_config']['PasswordAuthentication'] = 'yes'
  node.default['sshd']['sshd_config']['AuthenticationMethods'] = 'keyboard-interactive'
end

include_recipe 'sshd'
