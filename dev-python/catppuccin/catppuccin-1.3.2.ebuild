# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Catppuccin for Python"
HOMEPAGE="https://github.com/catppuccin/python/ https://pypi.org/project/catppuccin/"
SRC_URI="$(pypi_sdist_url "${PN^}" "${PV}")"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-python/pygments-2.13.0[${PYTHON_USEDEP}]
	>=dev-python/rich-13.3.5[${PYTHON_USEDEP}]
"
