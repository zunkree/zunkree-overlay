# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="LibYAML binding for Lua."
HOMEPAGE="http://yaml.luaforge.net/manual.html"
SRC_URI="http://files.luaforge.net/releases/yaml/yaml/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	exeinto /usr/lib/lua/5.1
	doexe yaml.so
}
