name                "duosecurity"
maintainer          "Articulate"
maintainer_email    "ops@articulate.com"
license             "MIT"
description         "Installs/Configures duosecurity"
long_description    IO.read(File.join(File.dirname(__FILE__), "README.md"))
version             "1.0.0"

supports            "ubuntu"
provides            "duosecurity::default"
recipe              "duosecurity::default", "Installs and configures login_duo"
depends             "ark"

