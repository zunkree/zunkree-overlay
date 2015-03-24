# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_3,3_4} )

inherit git-2 distutils-r1 user

DESCRIPTION="mongo-connector creates a pipeline from a MongoDB cluster to one or more target systems"
HOMEPAGE="https://github.com/10gen-labs/mongo-connector"
EGIT_REPO_URI="git://github.com/10gen-labs/mongo-connector.git"
EGIT_COMMIT="${PV}"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/pymongo-2.8[${PYTHON_USEDEP}]
	dev-python/elasticsearch-py[${PYTHON_USEDEP}]
	dev-python/pysolr[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
