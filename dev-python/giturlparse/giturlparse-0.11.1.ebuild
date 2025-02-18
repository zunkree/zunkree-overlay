# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 pypi

DESCRIPTION="Parse & rewrite git urls (supports GitHub, Bitbucket, FriendCode, Assembla, Gitlab ...)"
HOMEPAGE="https://github.com/nephila/giturlparse/ https://pypi.org/project/giturlparse/"
SRC_URI="$(pypi_sdist_url "${PN^}" "${PV}")"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

