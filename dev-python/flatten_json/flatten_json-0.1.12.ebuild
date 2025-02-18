# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Flattens JSON objects in Python."
HOMEPAGE="https://github.com/amirziai/flatten"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( >=dev-python/pytest-3.0.5[${PYTHON_USEDEP}] )"

# python_prepare_all() {
# 	sed -i -e "s/==.*$//" requirements.txt || die
# 	distutils-r1_python_prepare_all
# }
# 
# python_test() {
# 	py.test -v || die
# }
# 
