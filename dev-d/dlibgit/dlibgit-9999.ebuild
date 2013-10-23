# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit	git-2

DESCRIPTION="These are the D bindings to the libgit2 library."
HOMEPAGE="https://github.com/AndrejMitrovic/dlibgit"
EGIT_REPO_URI="https://github.com/s-ludwig/dlibgit.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="examples"

DEPEND=">=dev-lang/dmd-2.063"
RDEPEND="${DEPEND}
		dev-libs/libgit2"


pkg_setup(){
	if use x86 ; then MODEL="-m32" ; fi
	if use amd64 ; then MODEL="-m64" ; fi
}

src_compile() {
	dmd -fPIC ${MODEL} -lib -oflibdlibgit.a `find src -type f -name '*.d' -not -name 'package.d'` 
}

src_install() {
	dolib.a libdlibgit.a
	dodoc readme.md src/git/c/COPYING
	rm src/git/c/COPYING
	if use examples; then
		docompress -x /usr/share/doc/${PF}/samples/
		insinto /usr/share/doc/${PF}/samples/
		doins build.d
		doins -r samples/*
	fi
	insinto /usr/include/dlibgit/
	doins -r src/git
}
