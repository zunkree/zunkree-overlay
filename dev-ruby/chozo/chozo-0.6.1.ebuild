# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

inherit ruby-fakegem

DESCRIPTION="A collection of supporting libraries and Ruby core extensions"
HOMEPAGE="http://rubygems.org/gems/chozo"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/hashie:*"
ruby_add_rdepend ">=dev-ruby/activesupport-3.2.0:*"
ruby_add_rdepend ">=dev-ruby/multi_json-1.3.0"
