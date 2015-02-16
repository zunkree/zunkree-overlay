# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils multilib-build bash-completion-r1

DESCRIPTION="Reference compiler for the D programming language"
HOMEPAGE="http://dlang.org/"
SRC_URI="http://downloads.dlang.org/releases/2014/${PN}.${PV//_/-}.zip"

# DMD supports amd64/x86 exclusively
KEYWORDS="~amd64 ~x86"
SLOT="2"
IUSE="doc examples +tools"

# License doesn't allow redistribution
LICENSE="DMD"
RESTRICT="mirror"

COMMON_DEPEND="
	net-misc/curl[${MULTILIB_USEDEP}]
	"

BDEPEND="
	${COMMON_DEPEND}
	app-arch/unzip
	"

RDEPEND="
	${COMMON_DEPEND}
	!dev-lang/dmd-bin
	"

S="${WORKDIR}/${PN}2/src"

src_prepare() {
	cd .. || die

	# Remove precompiled binaries and non-essential files.
	rm -r README.TXT windows freebsd osx linux/{lib32,lib64} \
	linux/{bin32,bin64}/{README.TXT,dmd,dmd.conf} \
	|| die "Failed to remove included binaries"

	# convert line-endings of file-types that start as cr-lf and are patched or installed later on
	for file in $( find . -name "*.txt" -o -name "*.html" -o -name "*.d" -o -name "*.di" -o -name "*.ddoc" -type f ); do
		edos2unix $file || die "Failed to convert DOS line-endings to Unix."
	done

	cd src || die
	# patch: copy VERSION file into dmd directory for 2.063.2 release
	cp VERSION dmd/VERSION || die "Failed to copy VERSION into dmd directory"

	# Write a simple dmd.conf to bootstrap druntime and phobos
	echo "[Environment]" >> src/dmd/dmd.conf
	echo "DFLAGS=-L--export-dynamic" >> src/dmd/dmd.conf
}

abi_to_model() {
	[[ "${ABI:0:5}" == "amd64" ]] && echo 64 || echo 32
}

dmd_foreach_abi() {
	for ABI in $(multilib_get_enabled_abis); do
		local MODEL=$(abi_to_model)
		einfo "Executing ${1} in ${MODEL}-bit ..."
		"${@}"
	done
}

src_compile() {
	# A native build of dmd is used to compile the runtimes for both x86 and amd64
	# We cannot use multilib-minimal yet, as we have to be sure dmd for amd64
	# always gets build first.
	einfo "Building ${PN}..."
	emake -C dmd -f posix.mak TARGET_CPU=X86 RELEASE=1 MODEL=$(abi_to_model)

	compile_libraries() {
		einfo 'Building druntime...'
		emake -C druntime -f posix.mak MODEL=${MODEL} DMD=../dmd/dmd

		einfo 'Building Phobos 2...'
		emake -C phobos -f posix.mak MODEL=${MODEL} DMD=../dmd/dmd
	}

	dmd_foreach_abi compile_libraries
}

src_test() {
	test_hello_world() {
		src/dmd/dmd -m${MODEL} -Isrc/phobos -Isrc/druntime/import -L-Lsrc/phobos/generated/linux/release/${MODEL} samples/d/hello.d || die "Failed to build hello.d (${MODEL}-bit)"
		./hello ${MODEL}-bit || die "Failed to run test sample (${MODEL}-bit)"
		rm hello.o hello
	}

	dmd_foreach_abi test_hello_world
}

src_install() {
	einfo "Installing ${PN}..."

	# Compiler
	dobin dmd/dmd

	# prepeare and install config
	insinto /etc
	newins "${FILESDIR}/dmd-${PV}.conf" dmd.conf
	dobashcomp "${FILESDIR}/${PN}.bashcomp"

	# druntime
	install_druntime_lib() {
		newlib.a druntime/lib/libdruntime-linux${MODEL}.a libdruntime.a
		newlib.a druntime/lib/libdruntime-linux${MODEL}so.a libdruntimeso.a
		newlib.a druntime/lib/libdruntime-linux${MODEL}so.o libdruntimeso.o
	}
	dmd_foreach_abi install_druntime_lib
	insinto /usr/include/dlang/dmd
	doins -r druntime/import/*

	# Phobos
	install_phobos_lib() {
		rm phobos/generated/linux/release/${MODEL}/libphobos2.so.*.o
		dolib.a  phobos/generated/linux/release/${MODEL}/libphobos2.a
		dolib.so phobos/generated/linux/release/${MODEL}/libphobos2.so*
	}
	dmd_foreach_abi install_phobos_lib
	insinto /usr/include/dlang/dmd/std
	doins -r phobos/std/*
	rm -r "phobos/etc/c/zlib" || die
	insinto /usr/include/dlang/dmd/etc
	doins -r phobos/etc/*

	# Man pages, docs and samples
	doman ../man/man1/dmd.1
	doman ../man/man5/dmd.conf.5
	# Licenses
	newdoc dmd/backendlicense.txt BACKEND-LICENSE-dmd
	newdoc dmd/artistic.txt ARTISTIC-LICENSE-dmd
	newdoc druntime/LICENSE LICENSE-druntime
	newdoc phobos/LICENSE_1_0.txt LICENSE-phobos
	# Docs
	use doc && dohtml -r ../html/*
	# Samples
	docompress -x /usr/share/doc/${PF}/samples/
	insinto /usr/share/doc/${PF}/samples/
	use examples &&	doins -r ../samples/d/*

	if use tools; then
		doman ../man/man1/dumpobj.1
		doman ../man/man1/obj2asm.1
		doman ../man/man1/rdmd.1

		# Bundled pre-compiled tools
		if has_multilib_profile; then
			dobin ../linux/bin64/{ddemangle,dman,dumpobj,obj2asm,rdmd}
		else
			dobin ../linux/bin32/{ddemangle,dman,dumpobj,obj2asm,rdmd}
		fi
	fi
}

pkg_postinst() {
	if use doc || use examples; then
		elog "The bundled docs and/or samples may be found in"
		elog "/usr/share/doc/${PF}"
	fi
}
