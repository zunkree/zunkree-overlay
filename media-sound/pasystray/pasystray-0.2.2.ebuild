# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit gnome2-utils autotools

DESCRIPTION="PulseAudio system tray (replacement for padevchooser)"
HOMEPAGE="http://github.com/christophgysin/pasystray"
SRC_URI="https://github.com/christophgysin/${PN}/archive/${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify avahi"

RDEPEND=">=media-sound/pulseaudio-1.0[glib,avahi?]
	avahi? ( >=net-dns/avahi-0.6 )
	x11-libs/gtk+:3
	x11-libs/libX11
	libnotify? ( >=x11-libs/libnotify-0.7 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS README.md TODO"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_enable libnotify notify)
	econf $(use_enable avahi)
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
