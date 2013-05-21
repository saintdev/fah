# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=5

inherit eutils rpm versionator

# Source is available in fahviewer_X.y.z-XXbit-release.tar.bz2, but parts of the build
# system are missing.
MY_BASEURI="https://fah.stanford.edu/file-releases/public/release/fahviewer"
MY_64B_URI="${MY_BASEURI}/centos-5.3-64bit/v$(get_version_component_range 1-2)/fahviewer-${PV}-1.x86_64.rpm"
MY_32B_URI="${MY_BASEURI}/centos-5.5-32bit/v$(get_version_component_range 1-2)/fahviewer-${PV}-1.i686.rpm"

DESCRIPTION="Folding@home 3D Simulation Viewer"
HOMEPAGE="http://folding.stanford.edu/"
SRC_URI="x86? ( ${MY_32B_URI} )
	amd64? ( ${MY_64B_URI} )"

RESTRICT="fetch bindist strip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="x11-libs/libX11
	sys-libs/glibc
	app-arch/bzip2
	sys-libs/zlib
	dev-libs/expat
	media-libs/mesa"

S="${WORKDIR}"

I="opt/foldingathome"

QA_PREBUILT="${I}/FAHViewer"

pkg_setup() {
	I="${EROOT}${I}"
}

src_install() {
	exeinto "${I}"
	doexe usr/bin/FAHViewer

	dodir /usr/bin
	cat <<-EOF > "${D}"/usr/bin/FAHViewer
#!/bin/sh
exec ${I}/FAHViewer "\$@"
	EOF
	fperms +x /usr/bin/FAHViewer

	insinto /usr/share/pixmaps
	doins usr/share/pixmaps/FAHViewer-64.png

	make_desktop_entry FAHViewer FAHViewer FAHViewer-64 "" \
		"StartupNotify=false\nTerminal=false"

	dodoc usr/share/doc/fahviewer/{README,ChangeLog}
}
