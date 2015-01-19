# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools eutils

DESCRIPTION="Lua bindings to the cairo library"
HOMEPAGE="http://oocairo.naquadah.org/"
SRC_URI="http://oocairo.naquadah.org/dist/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-lang/lua-5.1
	x11-libs/cairo
"
DEPEND="
	dev-util/pkgconfig
	${RDEPEND}
"

src_prepare() {
	# sed "s/lua5.1/lua/g" -i configure.ac || die "sed failed"
	# eautoreconf
	epatch ${FILESDIR}/lua-oocairo-encoding.patch
}

src_install() {
	emake docdir="usr/share/doc/${PF}" DESTDIR="${D}" install || die "install failed"
}
