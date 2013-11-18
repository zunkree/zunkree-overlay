# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

inherit ruby-fakegem

DESCRIPTION="Evented IO for Celluloid actors"
HOMEPAGE="http://rubygems.org/gems/celluloid-io"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/celluloid-0.15.0
				  >=dev-ruby/nio4r-0.5.0"
