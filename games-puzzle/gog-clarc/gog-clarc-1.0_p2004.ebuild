# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO:
# - find out all required use flags for dependencies
# - find out all licenses on which package depends

EAPI="5"

CHECKREQS_DISK_BUILD=800M

inherit gog-games

DESCRIPTION="CLARC"
HOMEPAGE="https://www.gog.com/game/clarc"

SRC_URI="gog_clarc_2.0.0.4.sh"

KEYWORDS="-* ~amd64 ~x86"

RDEPEND="virtual/opengl[abi_x86_32(-)]
	x11-libs/libXau[abi_x86_32(-)]
	x11-libs/libXcursor[abi_x86_32(-)]
	x11-libs/libXdmcp[abi_x86_32(-)]
	x11-libs/libXfixes[abi_x86_32(-)]
	x11-libs/libXrender[abi_x86_32(-)]
	x11-libs/libxcb[abi_x86_32(-)]"
DEPEND=""

gog_pn="clarc"

src_install() {
	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/CLARC_LINUX_Data/Resources/UnityPlayer.png" . || die

	games_make_wrapper "${PN}" ./CLARC_LINUX.x86 "${dir}"
	newicon UnityPlayer.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}

	prepgamesdirs
}
