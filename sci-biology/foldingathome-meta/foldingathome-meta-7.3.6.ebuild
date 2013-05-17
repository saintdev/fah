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

# Comprehensive list of any and all USE flags leveraged in the ebuild,
# with the exception of any ARCH specific flags, i.e. "ppc", "sparc",
# "x86" and "alpha".  Not needed if the ebuild doesn't use any USE flags.
IUSE="+client control viewer"

RDEPEND="client? ( ~sci-biology/fahclient-${PV} )
		control? ( ~sci-biology/fahcontrol-${PV} )
		viewer? ( ~sci-biology/fahviewer-${PV} )"
