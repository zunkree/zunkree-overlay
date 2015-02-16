# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

inherit ruby-fakegem

DESCRIPTION="Building Web Service Security"
HOMEPAGE="http://rubygems.org/gems/akami"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/gyoku-0.4.0"
ruby_add_rdepend ">=dev-ruby/nokogiri-1.4.0"
