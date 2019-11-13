name                'duosecurity'
maintainer          'Matt Kulka'
maintainer_email    'matt@lqx.net'
license             'MIT'
description         'Installs/Configures duosecurity two-factor system authentication on Ubuntu/Debian'
long_description    IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version             '2.0.1'

source_url 'https://github.com/mattlqx/chef-duosecurity' if respond_to?(:source_url)
issues_url 'https://github.com/mattlqx/chef-duosecurity/issues' if respond_to?(:issues_url)

chef_version        '>= 14'

supports   'debian'
supports   'ubuntu'
depends    'ark'
depends    'pam'
depends    'sshd'
