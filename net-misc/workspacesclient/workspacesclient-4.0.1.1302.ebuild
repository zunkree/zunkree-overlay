# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

DESCRIPTION="AWS Workspaces Client"
HOMEPAGE="https://clients.amazonworkspaces.com/"
SRC_URI="https://d3nt0h4h6pmmc4.cloudfront.net/ubuntu/dists/bionic/main/binary-amd64/workspacesclient_${PV}_amd64.deb"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="bindist strip"

RDEPEND="
	x11-libs/gtk+:3
	net-libs/webkit-gtk:4
	net-libs/libsoup:2.4
"

QA_PREBUILT="/opt/${PN}/lib*/*"

S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	mv * "${D}" || die
}

