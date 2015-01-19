# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit dotnet

DESCRIPTION="Package manager for NuGet repositories"
HOMEPAGE="http://nuget.org/"
SRC_URI="http://origin-download.mono-project.com/sources/nuget/${P}+md54+dhx2.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="debug"

DEPEND=">=dev-lang/mono-1.0"

# S="${WORKDIR}/NUnit-${PV}"

src_compile() {
	./build-minimal.sh
}

src_install() {
	dobin ${FILESDIR}/nuget
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${FILESDIR}/nuget-core.pc
	exeinto /usr/$(get_libdir)/nuget
	doexe src/CommandLine/bin/Release/NuGet.Core.dll
	doexe xdt/XmlTransform/bin/Debug/Microsoft.Web.XmlTransform.dll
	doexe src/CommandLine/bin/Release/NuGet.exe
}
