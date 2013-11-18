# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

inherit ruby-fakegem

DESCRIPTION="A FFI wrapper around the system GSSAPI library. Please make sure and read the Yard docs or standard GSSAPI documentation if you have any questions. There is also a class called GSSAPI::Simple that wraps many of the common features used for GSSAPI."
HOMEPAGE="http://rubygems.org/gems/gssapi"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/ffi-1.0.1"
