# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

gog_pn="clarc"

CHECKREQS_DISK_BUILD=800M

inherit gog-games

DESCRIPTION="CLARC"

SRC_URI="gog_clarc_2.0.0.4.sh"

KEYWORDS="-* ~amd64 ~x86"

RDEPEND="dev-libs/atk[abi_x86_32(-)]
	dev-libs/glib:2[abi_x86_32(-)]
	media-libs/fontconfig[abi_x86_32(-)]
	media-libs/freetype[abi_x86_32(-)]
	virtual/glu[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/cairo[abi_x86_32(-)]
	x11-libs/gdk-pixbuf:2[abi_x86_32(-)]
	x11-libs/gtk+:2[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXcursor[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/pango[abi_x86_32(-)]"

DEPEND=""

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
