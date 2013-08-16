# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2

DESCRIPTION="Package manager for D packages"
HOMEPAGE="https://github.com/rejectedsoftware/dub"
EGIT_REPO_URI="https://github.com/rejectedsoftware/dub.git"
EGIT_COMMIT="v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-lang/dmd
		net-misc/curl"
RDEPEND="${DEPEND}"


src_compile() {
	./build.sh
}

src_install() {
	dobin bin/dub
	dodoc LICENSE.txt
}
