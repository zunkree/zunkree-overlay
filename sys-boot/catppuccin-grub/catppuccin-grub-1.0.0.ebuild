# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Catppuccin for Grub"
HOMEPAGE="https://github.com/catppuccin/grub"

EGIT_REPO_URI="https://github.com/catppuccin/grub.git"
EGIT_COMMIT="v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}
	sys-boot/grub[themes]
"
BDEPEND=""

src_install() {
	insinto /usr/share/grub/themes
	doins -r src/*
}

pkg_postinst() {
	elog "To use this theme:"
	elog
	elog "1. Have GRUB install this theme to /boot, by rerunning grub-install with"
	elog "your usual arguments and adding --themes:"
	elog
	elog "    grub-install ... --themes=catppuccin-grub-theme"
	elog
	elog "2. Tell GRUB to use the theme in /etc/default/grub:"
	elog
	elog "    GRUB_THEME=\"/boot/grub/themes/catppuccin-grub-theme/theme.txt\""
	elog
	elog "3. Regenerate grub.cfg to make your changes take effect:"
	elog
	elog "    # grub-mkconfig -o /boot/grub/grub.cfg"
}

