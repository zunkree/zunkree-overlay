# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils multilib bash-completion-r1

DESCRIPTION="Reference compiler for the D programming language"
HOMEPAGE="http://dlang.org/"
SRC_URI="http://downloads.dlang.org.s3.amazonaws.com/releases/2014/${PN}.${PV}.zip"

# DMD supports amd64/x86 exclusively
KEYWORDS="-* ~amd64 ~x86"
SLOT="2"
IUSE="multilib doc examples +tools"

# License doesn't allow redistribution
LICENSE="DMD"
RESTRICT="mirror"

DEPEND="sys-apps/findutils
	app-arch/unzip"
RDEPEND="!dev-lang/dmd-bin"

S="${WORKDIR}/${PN}2/src"

rdos2unix() {
	edos2unix $(find . -name '*'.$1 -type f) || die "Failed to convert line-endings of all .$1 files"
}

src_prepare() {
	cd .. || die

	rm -r README.TXT windows freebsd osx linux/{lib32,lib64} \
	linux/{bin32,bin64}/{README.TXT,dmd,dmd.conf} \
	|| die "Failed to remove included binaries"

	# convert line-endings of file-types that start as cr-lf and are
	# patched or installed later on
	rdos2unix c
	rdos2unix d
	rdos2unix txt
	rdos2unix css
	# patch: copy VERSION file into dmd directory for 2.063.2 release
	cp src/VERSION src/dmd/VERSION || die "Failed to copy VERSION into dmd directory"
}

src_compile() {
	# DMD
	if use x86; then
		einfo 'Building DMD for x86 ...'
		emake -C dmd -f posix.mak TARGET_CPU=X86 MODEL=32 RELEASE=1 PIC=1
	elif use amd64; then
		einfo 'Building DMD for amd64 ...'
		emake -C dmd -f posix.mak TARGET_CPU=X86 MODEL=64 RELEASE=1 PIC=1
	fi

	# druntime & Phobos
	if use x86 || (use amd64 && use multilib); then
		einfo 'Building druntime for x86 ...'
		emake -C druntime -f posix.mak MODEL=32 PIC=1 "DMD=../dmd/dmd"
		einfo 'Building Phobos for x86 ...'
		emake -C phobos -f posix.mak MODEL=32 PIC=1 "DMD=../dmd/dmd"
	fi
	if use amd64; then
		einfo 'Building druntime for amd64 ...'
		emake -C druntime -f posix.mak MODEL=64 PIC=1 "DMD=../dmd/dmd"
		einfo 'Building Phobos for amd64 ...'
		emake -C phobos -f posix.mak MODEL=64 PIC=1 "DMD=../dmd/dmd"
	fi
}

src_test() {
	local DFLAGS="-Iphobos -Idruntime/import -L-lrt"
	local DMD="dmd/dmd"
	if use x86 || (use amd64 && use multilib); then
		${DMD} -m32 ${DFLAGS} -Lphobos/generated/linux/release32/libphobos2.a ../samples/d/hello.d || die "Failed to build hello.d (32bit)"
		./hello 32bit || die "Failed to run test sample (32bit)"
	fi
	if use amd64; then
		${DMD} -m64 ${DFLAGS} -Lphobos/generated/linux/release64/libphobos2.a ../samples/d/hello.d || die "Failed to build hello.d (64bit)"
		./hello 64bit || die "Failed to run test sample (64bit)"
	fi
	rm hello.o hello
}

src_install() {
	einfo "Installing DMD"
	cd "dmd" || die

	# prepeare and install config
	insinto /etc
	doins "${FILESDIR}/dmd.conf"
	dobashcomp "${FILESDIR}/${PN}.bashcomp"

	# Compiler
	dobin "dmd"

	# Man pages, docs and samples
	cd ".." || die
	doman ../man/man1/*.1
	doman ../man/man5/*.5

	use doc && dohtml -r ../html/*

	if use tools; then
		doman ../man/man1/dumpobj.1
		doman ../man/man1/obj2asm.1
		doman ../man/man1/rdmd.1

		# Bundled pre-compiled tools
		if use amd64; then
			dobin ../linux/bin64/{ddemangle,dman,dumpobj,obj2asm,rdmd}
		fi
		if use x86; then
			dobin ../linux/bin32/{ddemangle,dman,dumpobj,obj2asm,rdmd}
		fi
	fi

	docompress -x /usr/share/doc/${PF}/samples/
	insinto /usr/share/doc/${PF}/samples/
	if use examples; then
		doins -r ../samples/d/*
	fi

	# druntime & Phobos
	if use amd64; then
		newlib.a druntime/lib/libdruntime-linux64.a libdruntime.a
		newlib.a druntime/lib/libdruntime-linux64so.a libdruntimeso.a
		rm phobos/generated/linux/release/64/libphobos2.so.*.o
		dolib.a  phobos/generated/linux/release/64/libphobos2.a
		dolib.so phobos/generated/linux/release/64/libphobos2.so*
	fi
	if use x86 || (use amd64 && use multilib); then
		use amd64 && multilib_toolchain_setup x86
		newlib.a druntime/lib/libdruntime-linux32.a libdruntime.a
		newlib.a druntime/lib/libdruntime-linux32so.a libdruntimeso.a
		rm phobos/generated/linux/release/32/libphobos2.so.*.o
		dolib.a  phobos/generated/linux/release/32/libphobos2.a
		dolib.so phobos/generated/linux/release/32/libphobos2.so*
	fi

	# cleanup builds
	rm -r "druntime/obj" "druntime/lib" || die
	rm -r "phobos/generated" || die

	# remove files that are not required
	rm "phobos/posix.mak" || die
	rm "phobos/win32.mak" || die
	rm "phobos/index.d" || die
	rm -r "phobos/etc/c/zlib" || die

	# imports
	insinto /usr/include/druntime/
	doins -r druntime/import/*

	insinto /usr/include/phobos2
	doins -r phobos/*
}

pkg_postinst() {
	if use doc || use examples; then
		elog "The bundled docs and/or samples may be found in"
		elog "/usr/share/doc/${PF}"
	fi
}
