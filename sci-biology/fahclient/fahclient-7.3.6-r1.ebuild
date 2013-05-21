# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="5"

inherit versionator user rpm

MY_BASEURI="https://fah.stanford.edu/file-releases/public/release/fahclient/"
MY_64B_URI="${MY_BASEURI}/centos-5.3-64bit/v$(get_version_component_range 1-2)/fahclient-${PV}-1.x86_64.rpm"
MY_32B_URI="${MY_BASEURI}/centos-5.5-32bit/v$(get_version_component_range 1-2)/fahclient-${PV}-1.i686.rpm"

DESCRIPTION="Folding@home Console Client"
HOMEPAGE="http://folding.stanford.edu/FAQ-SMP.html"
SRC_URI="x86? ( ${MY_32B_URI} )
	amd64? ( ${MY_64B_URI} )"

# Mirror is allowed for upstream, but the rpm is not mirrored
#RESTRICT="mirror bindist strip"
RESTRICT="fetch bindist strip"

LICENSE="FAH-EULA-2009 FAH-special-permission"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
# Expressly listing all deps, as this is a binpkg and it is doubtful whether
# i.e. uclibc or clang can provide what is necessary at runtime
RDEPEND="app-arch/bzip2
	sys-devel/gcc
	sys-libs/glibc
	sys-libs/zlib
	!sci-biology/foldingathome"

S="${WORKDIR}"

I="opt/foldingathome"

QA_PREBUILT="${I}/*"

pkg_setup() {
	I="${EROOT}${I}"
	enewuser foldingathome -1 -1 /var/lib/fahclient
	einfo ""
	cat "${PORTDIR}"/licenses/FAH-special-permission
	einfo ""
}

src_install() {
	dodoc usr/share/doc/fahclient/{README,sample-config.xml,ChangeLog}

	insinto /usr/share/pixmaps
	doins usr/share/pixmaps/FAHClient.png

	# TODO: Fix QA issues with this .desktop file
	domenu usr/share/applications/FAHWebControl.desktop

	exeinto "${I}"
	doexe usr/bin/{FAHClient,FAHCoreWrapper}
	doexe "${FILESDIR}"/$(get_version_component_range 1-2)/FAHInit

	dodir /usr/bin
	cat <<-EOF > "${D}"/usr/bin/FAHClient
#!/bin/sh
exec ${I}/FAHClient "\$@"
	EOF
	fperms +x /usr/bin/FAHClient

	newconfd "${FILESDIR}"/$(get_version_component_range 1-2)/conf.d FAHClient
	newinitd "${FILESDIR}"/$(get_version_component_range 1-2)/init.d FAHClient

	insinto /etc/fahclient
	doins "${FILESDIR}"/$(get_version_component_range 1-2)/config.xml

	keepdir /var/lib/fahclient

	for dir in "/var/lib/fahclient" "/etc/fahclient" ; do
		fowners -R foldingathome:nogroup "${dir}"
		fperms 755 "${dir}"
	done
}

pkg_postinst() {
	einfo "To run Folding@home in the background at boot:"
	einfo "\trc-update add FAHClient default"
	einfo ""
	elog  "If this is your first time installing, start the client, then"
	elog  "use FAHControl or visit http://folding.stanford.edu/client to"
	elog  "configure you username and team."
	elog  "Optionally, you can run emerge --config ${P} or"
	elog  "${I}/FAHInit"
	einfo ""
	einfo "If you would like to join the Gentoo folding team, it is team 36480."
}

pkg_config() {
	"${I}"/FAHInit
}
