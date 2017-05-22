name                "duosecurity"
maintainer          "Matt Kulka"
maintainer_email    "matt@lqx.net"
license             "MIT"
description         "Installs/Configures duosecurity two-factor system authentication on Ubuntu/Debian"
long_description    IO.read(File.join(File.dirname(__FILE__), "README.md"))
version             "1.3.4"

chef_version        '~> 12'

supports            "debian"
supports            "ubuntu"
recipe              "duosecurity::default", "Installs and configures login_duo"
recipe              "duosecurity::package", "Installs login_duo from package"
recipe              "duosecurity::source", "Installs login_duo from source"
depends             "ark"
depends             "pam"
depends             "sshd"
depends             "apt"
source_url          "https://github.com/articulate/chef-duosecurity" if respond_to?(:source_url)
issues_url          "https://github.com/mattlqx/chef-duosecurity/issues" if respond_to?(:issues_url)
