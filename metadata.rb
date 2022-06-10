# frozen_string_literal: true

name                'duosecurity'
maintainer          'Matt Kulka'
maintainer_email    'matt@lqx.net'
license             'MIT'
description         'Installs/Configures duosecurity two-factor system authentication on Ubuntu/Debian'
version             '3.0.1'

source_url 'https://github.com/mattlqx/chef-duosecurity'
issues_url 'https://github.com/mattlqx/chef-duosecurity/issues'

chef_version '>= 15.3'

supports   'debian'
supports   'ubuntu'
depends    'ark'
depends    'pam'
depends    'sshd'
