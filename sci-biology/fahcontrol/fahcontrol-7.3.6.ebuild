# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils python-r1 unpacker

DESCRIPTION="Folding@home Client Control"
HOMEPAGE="http://folding.stanford.edu/"

SRC_URI="https://fah.stanford.edu/file-releases/public/release/fahcontrol/debian-testing-64bit/v7.3/fahcontrol_7.3.6-1_all.deb"

LICENSE=""

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

# RESTRICT="fetch"
RESTRICT="primaryuri"

RDEPEND="dev-python/libgnome-python:2
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

impl_src_install() {
	dodir $(python_get_sitedir)
	cp -R "${S}"/usr/share/pyshared/fah/ "${D}/$(python_get_sitedir)"
}

src_install() {
	python_foreach_impl impl_src_install
	
	dobin usr/bin/FAHControl
	python_replicate_script "${D}"/usr/bin/FAHControl
	
	insinto /usr/share/pixmaps
	doins usr/share/pixmaps/FAHControl.png
	
	domenu usr/share/applications/FAHControl.desktop
	
	dodoc usr/share/doc/fahcontrol/{changelog.Debian.gz,changelog.gz,copyright}
}