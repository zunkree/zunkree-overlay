# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

inherit ruby-fakegem

DESCRIPTION="New IO for Ruby"
HOMEPAGE="http://rubygems.org/gems/nio4r"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

each_ruby_configure() {
	${RUBY} -Cext/nio4r extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/nio4r
	cp ext/nio4r/nio4r_ext.so lib/ || die
}
