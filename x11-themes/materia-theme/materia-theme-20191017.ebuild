# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

DESCRIPTION="A Material Design-like flat theme for GTK3, GTK2 and GNOME Shell"
HOMEPAGE="https://github.com/nana-4/materia-theme"

SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~x86 ~amd64"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	x11-libs/gtk+:2
	>=x11-libs/gtk+-3.18:3
	>=x11-themes/gnome-themes-standard-3.18
	x11-libs/gdk-pixbuf
"
RDEPEND="${DEPEND}"

src_install(){
	mkdir -p "${D}/usr/share/themes"
	./install.sh --dest "${D}/usr/share/themes" || die "failed to install"
}
