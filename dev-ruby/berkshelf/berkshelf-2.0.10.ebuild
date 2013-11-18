# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

inherit ruby-fakegem

DESCRIPTION="Manages a Cookbook's, or an Application's, Cookbook dependencies"
HOMEPAGE="https://github.com/berkshelf/berkshelf"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/activesupport-3.2.0
				  >=dev-ruby/addressable-2.3.4
				  >=dev-ruby/buff-shell_out-0.1
				  >=dev-ruby/chozo-0.6.1
				  >=dev-ruby/faraday-0.8.5
				  >=dev-ruby/hashie-2.0.2
				  >=dev-ruby/archive-tar-minitar-0.5.4
				  >=dev-ruby/rbzip2-0.2.0
				  >=dev-ruby/retryable-1.3.3
				  >=dev-ruby/ridley-1.5.0
				  >=dev-ruby/solve-0.5.0
				  >=dev-ruby/thor-0.18.0"
