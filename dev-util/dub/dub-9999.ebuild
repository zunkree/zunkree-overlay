# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2

DESCRIPTION="Package manager for D packages"
HOMEPAGE="https://github.com/rejectedsoftware/dub"
EGIT_REPO_URI="https://github.com/rejectedsoftware/dub.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples"

DEPEND="dev-lang/dmd
		net-misc/curl"
RDEPEND="${DEPEND}"

src_compile() {
	./build.sh
}

src_install() {
	dobin bin/dub
	dodoc LICENSE.txt CHANGELOG.md README.md
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples/
		insinto /usr/share/doc/${PF}/examples/
		doins -r examples/*
	fi
}
