# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils multilib-build bash-completion-r1 versionator

DESCRIPTION="Reference compiler for the D programming language"
HOMEPAGE="http://dlang.org/"
SRC_URI="http://ftp.digitalmars.com/${PN}.${PV//_/-}.zip"

# License doesn't allow redistribution
LICENSE="DMD"

DLANG_VERSION="$(get_version_component_range 1-2)"

# DMD supports amd64/x86 exclusively
MULTILIB_COMPAT=( abi_x86_{32,64} )
KEYWORDS=""
SLOT="${DLANG_VERSION}"
IUSE="doc examples tools"

COMMON_DEPEND="
	net-misc/curl[${MULTILIB_USEDEP}]
	>=app-admin/eselect-dlang-2015032800
	"

DEPEND="
	${COMMON_DEPEND}
	app-arch/unzip
	"
RDEPEND="
	${COMMON_DEPEND}
	!dev-lang/dmd-bin
	"
S="${WORKDIR}/dmd2"

BIN_PREFIX="${EPREFIX}/usr/${CHOST}/dmd-bin/${SLOT}"
LIB_PREFIX="${EPREFIX}/usr/lib/${CHOST}/dmd/${SLOT}"
DOC_PREFIX="${EPREFIX}/usr/share/dmd-data/${CHOST}/${SLOT}"

src_prepare() {
	# Remove precompiled binaries and non-essential files.
	rm -r README.TXT windows freebsd osx linux/{lib32,lib64} \
	linux/{bin32,bin64}/{README.TXT,dmd,dmd.conf} \
	|| die "Failed to remove included binaries"

	# Convert line-endings of file-types that start as cr-lf and are installed later on
	for file in $( find . -name "*.txt" -o -name "*.html" -o -name "*.d" -o -name "*.di" -o -name "*.ddoc" -type f ); do
		edos2unix $file || die "Failed to convert DOS line-endings to Unix."
	done

	# Write a simple dmd.conf to bootstrap druntime and phobos
	echo "[Environment]" > src/dmd/dmd.conf
	echo "DFLAGS=-L--export-dynamic" >> src/dmd/dmd.conf

	# Fix the messy directory layout so the three make files can cooperate
	mv src/druntime druntime
	mv src/phobos phobos
	mv src dmd
	mv dmd/dmd dmd/src

	# Temporary fix for recompilation of Phobos during installation
	# epatch "${FILESDIR}/${PV}-phobos-makefile.patch"
	epatch_user
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
	emake -C dmd/src -f posix.mak TARGET_CPU=X86 RELEASE=1

	compile_libraries() {
		einfo 'Building druntime...'
		emake -C druntime -f posix.mak MODEL=${MODEL} PIC=1

		einfo 'Building Phobos 2...'
		emake -C phobos -f posix.mak MODEL=${MODEL} PIC=1
	}

	dmd_foreach_abi compile_libraries
}

src_test() {
	test_hello_world() {
		dmd/src/dmd -m${MODEL} -Iphobos -Idruntime/import -L-Lphobos/generated/linux/release/${MODEL} samples/d/hello.d || die "Failed to build hello.d (${MODEL}-bit)"
		./hello ${MODEL}-bit || die "Failed to run test sample (${MODEL}-bit)"
		rm hello.o hello
	}

	dmd_foreach_abi test_hello_world
}

src_install() {
	local MODEL=$(abi_to_model)

	# Prepeare dmd.conf
	local DMD_CONFIG="dmd/ini/linux/bin${MODEL}/dmd.conf"
	mkdir -p $(dirname ${DMD_CONFIG}) || die "Failed to create directory: $(dirname ${DMD_CONFIG})"
	if has_multilib_profile; then
		echo "[Environment]" > ${DMD_CONFIG}
		echo "DFLAGS=-I${LIB_PREFIX}/import -L--export-dynamic" >> ${DMD_CONFIG}
		install_config() {
			echo "[Environment${MODEL}]" >> ${DMD_CONFIG}
			echo "DFLAGS=%DFLAGS% -L-L${LIB_PREFIX}/$(get_libdir) -L-rpath -L${LIB_PREFIX}/$(get_libdir)" >> ${DMD_CONFIG}
		}
		dmd_foreach_abi install_config
	else
		echo "[Environment]" > ${DMD_CONFIG}
		echo "DFLAGS=-I${LIB_PREFIX}/import -L--export-dynamic" >> ${DMD_CONFIG}
		echo "DFLAGS=%DFLAGS% -L-L${LIB_PREFIX}/$(get_libdir) -L-rpath -L${LIB_PREFIX}/$(get_libdir)" > ${DMD_CONFIG}
	fi

	# DMD
	einfo "Installing ${PN}..."
	emake -C dmd/src -f posix.mak TARGET_CPU=X86 RELEASE=1 install
	insinto "${BIN_PREFIX}"
	doins install/linux/bin${MODEL}/dmd
	chmod a+x ${D}${BIN_PREFIX}/dmd
	dosym ${BIN_PREFIX}/dmd /usr/bin/dmd-${DLANG_VERSION}
	doins install/linux/bin${MODEL}/dmd.conf
	insinto "${DOC_PREFIX}"
	doins install/dmd-{boostlicense,backendlicense}.txt


	einfo 'Installing druntime...'
	install_druntime() {
		emake -C druntime -f posix.mak LIB_DIR="$(get_libdir)" MODEL=${MODEL} install
	}
	dmd_foreach_abi install_druntime
	insinto "${LIB_PREFIX}"
	doins -r install/src/druntime/import
	insinto "${DOC_PREFIX}"
	doins install/druntime-LICENSE.txt

	einfo 'Installing Phobos 2...'
	install_library() {
		emake -C phobos -f posix.mak LIB_DIR="$(get_libdir)" MODEL=${MODEL} install
		into "${LIB_PREFIX}"
		dolib.a install/linux/lib${MODEL}/libphobos2.a
		dolib.so install/linux/lib${MODEL}/libphobos2.so.0.67.0
		dolib.so install/linux/lib${MODEL}/libphobos2.so
		dosym libphobos2.so.0.67.0 "${LIB_PREFIX}/$(get_libdir)"/libphobos2.so.0.67
	}
	dmd_foreach_abi install_library
    insinto "${LIB_PREFIX}/import"
    doins -r install/src/phobos/*
    insinto "${DOC_PREFIX}"
    doins install/phobos-LICENSE.txt

    # dir for imoirt symlink
    keepdir /usr/include/dlang

    # man pages, docs and samples
    insinto "${DOC_PREFIX}/man/man1"
    doins man/man1/dmd.1
    insinto "${DOC_PREFIX}/man/man5"
    doins man/man5/dmd.conf.5
    if use doc ; then
        insinto "${DOC_PREFIX}"
        doins -r html
    fi
    if use examples; then
        docompress -x "${DOC_PREFIX}/samples"
        insinto "${DOC_PREFIX}/sample"
        doins -r samples/d/*
    fi
	if use tools; then
		insinto "${DOC_PREFIX}/man/man1"
		doins man/man1/dumpobj.1
		doins man/man1/obj2asm.1
		doins man/man1/rdmd.1

		# Bundled pre-compiled tools
		insinto "${BIN_PREFIX}"
		if has_multilib_profile; then
			doins linux/bin64/{ddemangle,dman,dumpobj,obj2asm,rdmd}
		else
			doins linux/bin32/{ddemangle,dman,dumpobj,obj2asm,rdmd}
		fi
		chmod a+x ${D}${BIN_PREFIX}/{ddemangle,dman,dumpobj,obj2asm,rdmd}
	fi
}

pkg_postinst() {
	# Update active dmd
	einfo "${ROOT}"/usr/bin/eselect dlang update dmd

	elog "License files are in: ${DOC_PREFIX}"
	use examples && elog "Examples can be found in: ${DOC_PREFIX}/samples"
	use doc && elog "HTML documentation is in: ${DOC_PREFIX}/html"
}

pkg_postrm() {
	einfo "${ROOT}"/usr/bin/eselect dlang update dmd
}
