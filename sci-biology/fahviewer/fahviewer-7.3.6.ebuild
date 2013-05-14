# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=5

inherit eutils unpacker versionator

MY_BASEURI="https://fah.stanford.edu/file-releases/public/release/fahviewer"
MY_64B_URI="${MY_BASEURI}/debian-testing-64bit/v$(get_version_component_range 1-2)/fahviewer_${PV}_amd64.deb"
MY_32B_URI="${MY_BASEURI}/debian-testing-32bit/v$(get_version_component_range 1-2)/fahviewer_${PV}_i386.deb"

DESCRIPTION="Folding@home 3D Simulation Viewer"
HOMEPAGE="http://folding.stanford.edu/"
SRC_URI="x86? ( ${MY_32B_URI} )
	amd64? ( ${MY_64B_URI} )"

RESTRICT="fetch bindist strip"

LICENSE=""
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

src_install() {
	exeinto ${I}
	doexe usr/bin/FAHViewer
	
	dodir /usr/bin
	cat <<-EOF > "${D}"/usr/bin/FAHViewer
#!/bin/sh
exec ${I}/FAHViewer "\$@"
	EOF
	fperms +x /usr/bin/FAHViewer
	
	insinto /usr/share/pixmaps
	doins usr/share/pixmaps/FAHViewer-64.png
	
	domenu usr/share/applications/FAHViewer.desktop
	
	dodoc usr/share/doc/fahviewer/{README,changelog.Debian.gz,changelog.gz,copyright}
}
