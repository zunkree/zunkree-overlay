# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Catppuccin for GTK"
HOMEPAGE="https://github.com/catppuccin/gtk"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+latte +frappe +macchiato +mocha"

EGIT_REPO_URI="https://github.com/catppuccin/gtk.git"
EGIT_COMMIT="v${PV}"

DEPEND=">=dev-python/catppuccin-1.1.1"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install(){
	mkdir -p "${D}/usr/share/themes"
	for flavor in latte frappe macchiato mocha ; do
		if use ${flavor} ; then
			python ./install.py ${flavor} --dest "${D}/usr/share/themes" || die "failed to install"
		fi
    done
}

