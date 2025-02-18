# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake systemd

DESCRIPTION="A GlobalProtect VPN client (GUI) for Linux based on Openconnect."
HOMEPAGE="https://github.com/yuezk/GlobalProtect-openconnect"

EGIT_REPO_URI="https://github.com/yuezk/${PN}.git"
EGIT_COMMIT="v${PV}"
EGIT_SUBMODULES=('*')

EGIT_OVERRIDE_REPO_GIT_GITHUB_COM_FRANKOSTERFELD_QTKEYCHAIN="https://github.com/frankosterfeld/qtkeychain.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtwebengine:5
	dev-qt/qtwebsockets:5
	dev-qt/qtdbus:5
	>=net-vpn/openconnect-8
	dev-libs/qtkeychain[qt5]
	"
RDEPEND="${DEPEND}"
BDEPEND=""

CMAKE_MAKEFILE_GENERATOR="emake"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_CXX_FLAGS_RELEASE=-s
	)
	cmake_src_configure
}

