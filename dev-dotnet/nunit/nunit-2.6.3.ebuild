# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit dotnet

DESCRIPTION="Unit test framework for CLI"
HOMEPAGE="http://www.nunit.org/"
SRC_URI="http://launchpad.net/nunitv2/trunk/${PV}/+download/NUnit-${PV}-src.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="debug"

DEPEND=">=dev-lang/mono-1.0
		app-arch/unzip"

S="${WORKDIR}/NUnit-${PV}"

src_prepare() {
	use debug && config="Debug" || config="Release"
	buildpath="bin/${config}"
}

src_compile() {
	xbuild /property:Configuration=${config} ./src/NUnitCore/core/nunit.core.dll.csproj
	xbuild /property:Configuration=${config} ./src/NUnitCore/interfaces/nunit.core.interfaces.dll.csproj
	xbuild /property:Configuration=${config} ./src/NUnitFramework/framework/nunit.framework.dll.csproj
	xbuild /property:Configuration=${config} ./src/NUnitMocks/mocks/nunit.mocks.csproj
	xbuild /property:Configuration=${config} ./src/ClientUtilities/util/nunit.util.dll.csproj
	xbuild /property:Configuration=${config} ./src/ConsoleRunner/nunit-console/nunit-console.csproj
	xbuild /property:Configuration=${config} ./src/ConsoleRunner/nunit-console-exe/nunit-console.exe.csproj
	xbuild /property:Configuration=${config} ./src/GuiRunner/nunit-gui/nunit-gui.csproj
	xbuild /property:Configuration=${config} ./src/GuiComponents/UiKit/nunit.uikit.dll.csproj
	xbuild /property:Configuration=${config} ./src/GuiException/UiException/nunit.uiexception.dll.csproj
	xbuild /property:Configuration=${config} ./src/GuiRunner/nunit-gui-exe/nunit-gui.exe.csproj
}

src_install() {
	newbin ${FILESDIR}/nunit-gui nunit-gui-2.6
	newbin ${FILESDIR}/nunit-console nunit-console-2.6
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${FILESDIR}/nunit.pc
	newins ${FILESDIR}/nunit.pc NUnit.pc
	insinto /usr/$(get_libdir)/nunit
	newins src/ConsoleRunner/nunit-console-exe/App.config nunit-console.exe.config
	newins src/GuiRunner/nunit-gui-exe/App.config nunit.exe.config
	exeinto /usr/$(get_libdir)/nunit
	for name in `find ${buildpath} -name '*.dll'` ; do
		doexe ${name}
	done
	for name in `find ${buildpath} -name '*.exe'` ; do
		doexe ${name}
	done
	for name in nunit-console-runner.dll nunit.core.dll nunit.core.interfaces.dll nunit.framework.dll nunit.mocks.dll nunit.util.dll ; do
		gacutil  -i ${D}/usr/$(get_libdir)/nunit/${name} -package nunit -root "${D}"/usr/$(get_libdir) -gacdir /usr/$(get_libdir)
		rm -f ${D}/usr/$(get_libdir)/nunit/${name}
	done
}
