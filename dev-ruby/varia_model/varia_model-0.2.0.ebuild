# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

inherit ruby-fakegem

DESCRIPTION="A mixin to provide objects with magic attribute reading and writing"
HOMEPAGE="http://rubygems.org/gems/varia_model"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/buff-extensions-0.2.0
				  >=dev-ruby/hashie-2.0.2"
