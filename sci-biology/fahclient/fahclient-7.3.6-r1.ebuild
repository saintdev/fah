# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="5"

inherit versionator user unpacker

MY_BASEURI="https://fah.stanford.edu/file-releases/public/release/fahclient/"
MY_64B_URI="${MY_BASEURI}/debian-testing-64bit/v$(get_version_component_range 1-2)/fahclient_${PV}_amd64.deb"
MY_32B_URI="${MY_BASEURI}/debian-testing-32bit/v$(get_version_component_range 1-2)/fahclient_${PV}_i386.deb"

DESCRIPTION="Folding@home Console Client"
HOMEPAGE="http://folding.stanford.edu/FAQ-SMP.html"
SRC_URI="x86? ( ${MY_32B_URI} )
	amd64? ( ${MY_64B_URI} )"

RESTRICT="fetch bindist strip"

LICENSE="FAH-EULA-2009"
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
}

src_install() {
	dodoc usr/share/doc/fahclient/{copyright,README,sample-config.xml,changelog.Debian.gz,changelog.gz}

	insinto /usr/share/pixmaps
	doins usr/share/pixmaps/FAHClient.png

	domenu usr/share/applications/FAHWebControl.desktop

	exeinto "${I}"
	doexe usr/bin/{FAHClient,FAHCoreWrapper}

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
	einfo "If this is your first time installing the client, you should visit"
	einfo "http://folding.stanford.edu/client or use FAHControl, after starting"
	einfo "the client, to configure it."
	einfo ""
	einfo "If you would like to join the Gentoo folding team, it is team 36480."
}
