name                'duosecurity'
maintainer          'Matt Kulka'
maintainer_email    'matt@lqx.net'
license             'MIT'
description         'Installs/Configures duosecurity two-factor system authentication on Ubuntu/Debian'
long_description    IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version             '1.3.7'

chef_version        '>= 12.1'

supports   'debian'
supports   'ubuntu'

depends    'ark', '~> 3.1'
depends    'pam', '~> 1.1'
depends    'sshd', '~> 1.3'
depends    'apt', '~> 7.0'
source_url 'https://github.com/mattlqx/chef-duosecurity' if respond_to?(:source_url)
issues_url 'https://github.com/mattlqx/chef-duosecurity/issues' if respond_to?(:issues_url)
