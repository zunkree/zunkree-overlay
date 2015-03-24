# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3,3_4} )

inherit distutils-r1 git-2

DESCRIPTION="Lightweight python wrapper for Apache Solr"
HOMEPAGE="https://github.com/toastdriven/pysolr https://pypi.python.org/pypi/pysolr"
EGIT_REPO_URI="git://github.com/toastdriven/pysolr.git"
EGIT_COMMIT="v${PV}"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="tomcat"

DEPEND="dev-python/requests[${PYTHON_USEDEP}]
	tomcat? (
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/cssselect[${PYTHON_USEDEP}]
	)"
RDEPEND="${DEPEND}"
