# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=5

inherit eutils

DESCRIPTION="Folding@home meta ebuild"
HOMEPAGE="http://folding.stanford.edu/"

LICENSE="metapackage"

SLOT="0"

KEYWORDS="~x86 ~amd64"

IUSE="+client control viewer"

RDEPEND="client? ( ~sci-biology/fahclient-${PV} )
		control? ( ~sci-biology/fahcontrol-${PV} )
		viewer? ( ~sci-biology/fahviewer-${PV} )"
