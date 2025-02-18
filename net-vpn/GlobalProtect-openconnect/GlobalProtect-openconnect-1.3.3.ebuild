# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 qmake-utils

DESCRIPTION="A GlobalProtect VPN client (GUI) for Linux based on Openconnect."
HOMEPAGE="https://github.com/yuezk/GlobalProtect-openconnect"

EGIT_REPO_URI="https://github.com/yuezk/${PN}.git"
EGIT_COMMIT="v${PV}"
EGIT_SUBMODULES=('*')

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtwebengine:5
	dev-qt/qtwebsockets:5
	dev-qt/qtdbus:5
	>=net-vpn/openconnect-8
	"
RDEPEND="${DEPEND}"
BDEPEND=""

BUILD_DIR="${WORKDIR}/build"

# src_prepare() {
#	cmake_src_prepare
#}

src_configure() {
	eqmake5 CONFIG+=release
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

