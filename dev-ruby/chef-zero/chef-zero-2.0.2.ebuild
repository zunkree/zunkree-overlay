# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

inherit ruby-fakegem

DESCRIPTION="Self-contained, easy-setup, fast-start in-memory Chef server for testing and solo setup purposes"
HOMEPAGE="https://rubygems.org/gems/chef-zero"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/json"
ruby_add_rdepend "dev-ruby/rack:*"
ruby_add_rdepend "dev-ruby/hashie:*"
ruby_add_rdepend ">=dev-ruby/mixlib-log-1.3"
