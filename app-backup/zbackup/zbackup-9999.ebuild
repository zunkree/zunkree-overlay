# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2 cmake-utils

DESCRIPTION="A versatile deduplicating backup tool"
HOMEPAGE="http://zbackup.org/"
EGIT_REPO_URI="git://github.com/zbackup/zbackup.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="app-arch/lzma
		dev-libs/lzo
		dev-libs/openssl
		dev-libs/protobuf
		sys-libs/zlib"
RDEPEND="${DEPEND}"
