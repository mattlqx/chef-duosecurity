name                "duosecurity"
maintainer          "Articulate"
maintainer_email    "ops@articulate.com"
license             "MIT"
description         "Installs/Configures duosecurity"
long_description    IO.read(File.join(File.dirname(__FILE__), "README.md"))
issues_url          "https://github.com/articulate/chef-duosecurity/issues"
source_url          "https://github.com/articulate/chef-duosecurity"
version             "0.2.0"

supports            "ubuntu"
provides            "duosecurity::default"
recipe              "duosecurity::default", "Installs and configures login_duo"
depends             "ark"

