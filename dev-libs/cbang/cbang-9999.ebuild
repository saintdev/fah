# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=5
inherit eutils scons-utils subversion

DESCRIPTION="A collection of C++ utility libraries"
HOMEPAGE="http://cbang.org/"
ESVN_REPO_URI="https://cauldrondevelopment.com/svn/cbang/trunk/cbang"

ESVN_PATCHES="${FILESDIR}/0001-Remove-.deb-Package-from-SConstruct.patch"

LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS=""

IUSE="+static"

RDEPEND="app-arch/bzip2
	sys-libs/zlib
	dev-libs/libxml2
	dev-libs/openssl
	dev-db/sqlite
	dev-libs/boost"

DEPEND="${RDEPEND}"

src_configure() {
	myesconsargs=(
		$(use_scons static staticlib)
		sharedlib=1
	)
}

src_compile() {
	escons
}

src_install() {
	escons prefix="${D}/usr" install
	dosym libcbang0.so.0.0.1 /usr/lib/libcbang0.so

	insinto /usr/share/cbang
	doins -r config-scripts
}
