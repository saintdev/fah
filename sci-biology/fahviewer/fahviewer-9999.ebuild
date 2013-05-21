# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=5
inherit eutils scons-utils subversion

DESCRIPTION="Folding@home 3D Simulation Viewer"
HOMEPAGE="http://folding.stanford.edu/"
ESVN_REPO_URI="https://fah-web.stanford.edu/svn/pub/trunk/viewer"

LICENSE="GPL-2+"
SLOT="0"

KEYWORDS=""

IUSE=""

RDEPEND="dev-libs/cbang[static]
	<sci-chemistry/gromacs-4.6.0
	sci-libs/gsl
	media-libs/freeglut
	media-libs/glew
	media-libs/glu
	media-libs/freetype
	dev-libs/boost"

DEPEND="${RDEPEND}"

src_prepare() {
	# Modified copy of cbang-config.py from cbang SVN r318
	cp "${FILESDIR}"/cbang-config-r318.py "${S}"/cbang-config.py
	subversion_bootstrap
}

src_compile() {
	export CONFIG_SCRIPTS_HOME="/usr/share/cbang/config-scripts"
	escons
}

src_install() {
	dobin FAHViewer

	insinto /usr/share/pixmaps
	doins images/FAHViewer-64.png

	make_desktop_entry FAHViewer FAHViewer FAHViewer-64 "" \
		"StartupNotify=false\nTerminal=false"

	dodoc ChangeLog README
}
