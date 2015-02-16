# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

inherit ruby-fakegem

DESCRIPTION="Puma is a simple, fast, and highly concurrent HTTP 1.1 server for Ruby web applications."
HOMEPAGE="https://rubygems.org/gems/puma/versions/1.6.3-java"

LICENSE="BSD"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rack-1.2"
