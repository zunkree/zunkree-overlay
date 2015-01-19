# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/go-mtpfs/go-mtpfs-9999.ebuild,v 1.5 2014/01/28 01:13:50 zerochaos Exp $

EAPI=5

inherit git-r3 flag-o-matic toolchain-funcs

DESCRIPTION="a simple FUSE filesystem for mounting Android devices as a MTP device"
GO_PN="github.com/hanwen/usb"
HOMEPAGE="https://${GO_PN}"
EGIT_REPO_URI="https://${GO_PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="virtual/libusb
		virtual/udev"
DEPEND="${COMMON_DEPEND}
	dev-libs/go-fuse
	dev-lang/go"

RDEPEND="${COMMON_DEPEND}"

#Tests require a connected mtp device
RESTRICT="test"

EGIT_CHECKOUT_DIR="${S}/src/${GO_PN}"

export GOPATH="${S}"

src_install() {
	cd "${S}/src/${GO_PN}"
	dodoc LICENSE README.md
	insinto /usr/lib/go/src/pkg/github.com/hanwen/usb
	doins "${S}/src/${GO_PN}"/print.go
	doins "${S}/src/${GO_PN}"/usb.go
}
