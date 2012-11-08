# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils savedconfig versionator

MY_PN="idea"
MY_MAJORV="$(get_major_version)"
MY_PV="$(get_after_major_version)"

DESCRIPTION="IntelliJ IDEA is an intelligent Java IDE"
HOMEPAGE="http://jetbrains.com/idea/"
SRC_URI="http://download.jetbrains.com/${MY_PN}/${MY_PN}IU-${MY_PV}.tar.gz"

LICENSE="IntelliJ-IDEA"
SLOT="12"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=virtual/jdk-1.6"

S="${WORKDIR}/${MY_PN}-IU-${MY_PV}"
RESTRICT="strip"

DIR="/opt/${P}"

QA_TEXTRELS="${DIR}/bin/libbreakgen.so"

CONFIG="
	bin/idea.vmoptions
	bin/idea64.vmoptions
	bin/idea.properties
"

pkg_setup() {
	if [[ -d /etc/portage/savedconfig/${CATEGORY}/${PN}-${MY_MAJORV} ]] ; then
	# stupid saveconfig.eclass cannot work with major version of the software
		cp -r /etc/portage/savedconfig/${CATEGORY}/${PN}-${MY_MAJORV} /etc/portage/savedconfig/${CATEGORY}/${PF}
		elog "Copying saved config from generic"
		elog "/etc/portage/savedconfig/${CATEGORY}/${PN}-${MY_MAJORV}"
		elog "to package specific"
		elog "/etc/portage/savedconfig/${CATEGORY}/${PF}"
		elog "directory"
	fi
}

src_configure() {
	restore_config $CONFIG
}

src_install() {
	local exe="${PN}-${SLOT}"

	insinto "${DIR}"
	doins -r *
	fperms 755 "${DIR}/bin/${MY_PN}.sh" "${DIR}/bin/fsnotifier" "${DIR}/bin/fsnotifier64"

	newicon "bin/${MY_PN}.png" "${exe}.png"
	make_wrapper "${exe}" "${DIR}/bin/${MY_PN}.sh"
	make_desktop_entry ${exe} "Early access version of the upcoming IntelliJ IDEA ${MY_MAJORV} (Ultimate Edition)" "${exe}" "Development;IDE"

	save_config $CONFIG
}

pkg_postinst() {
	mv -f /etc/portage/savedconfig/${CATEGORY}/${PF} /etc/portage/savedconfig/${CATEGORY}/${PN}-${MY_MAJORV}
	elog "Moving config from package specific"
	elog "/etc/portage/savedconfig/${CATEGORY}/${PF}"
	elog "to generic"
	elog "/etc/portage/savedconfig/${CATEGORY}/${PN}-${MY_MAJORV}"
	elog "directory"
}
