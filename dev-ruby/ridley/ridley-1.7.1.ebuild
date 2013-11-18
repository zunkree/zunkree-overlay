# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

inherit ruby-fakegem

DESCRIPTION="A reliable Chef API client with a clean syntax"
HOMEPAGE="http://rubygems.org/gems/ridley"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/addressable
				  >=dev-ruby/buff-config-0.2
				  >=dev-ruby/buff-extensions-0.3
				  >=dev-ruby/buff-ignore-1.1
				  >=dev-ruby/buff-shell_out-0.1
				  >=dev-ruby/celluloid-0.15
				  >=dev-ruby/celluloid-io-0.15
				  dev-ruby/erubis
				  >=dev-ruby/faraday-0.8.4
				  >=dev-ruby/hashie-2.0.2
				  >=dev-ruby/json-1.7.7
				  >=dev-ruby/mixlib-authentication-1.3.0
				  >=dev-ruby/net-http-persistent-2.8
				  dev-ruby/net-ssh
				  dev-ruby/retryable
				  >=dev-ruby/solve-0.4.4
				  >=dev-ruby/varia_model-0.1
				  >=dev-ruby/winrm-1.1.0"
