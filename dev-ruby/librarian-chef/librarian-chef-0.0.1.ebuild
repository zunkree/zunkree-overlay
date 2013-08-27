# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

inherit ruby-fakegem

DESCRIPTION="Librarian-Chef is a bundler for your Chef-based infrastructure repositories."
HOMEPAGE="https://github.com/applicationsonline/librarian-chef"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/archive-tar-minitar-0.5.2
				  >=app-admin/chef-0.10
				  >=dev-ruby/librarian-0.1.0"
