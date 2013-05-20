# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils subversion distutils-r1

DESCRIPTION="Folding@home Client Control"
HOMEPAGE="http://folding.stanford.edu/"
ESVN_REPO_URI="https://fah-web.stanford.edu/svn/pub/trunk/control"

LICENSE="GPL-3+"
SLOT="0"

KEYWORDS=""

IUSE=""

RDEPEND="dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"

DEPEND="${RDEPEND}"

DOC=( README.txt ChangeLog )

python_install_all() {
	make_desktop_entry FAHControl FAHControl FAHControl "" \
		"StartupNotify=false\nTerminal=false"

	distutils-r1_python_install_all
}
