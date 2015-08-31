# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO:
# - find out all required use flags for dependencies
# - find out all licenses on which package depends

EAPI="5"

CHECKREQS_DISK_BUILD=70M

inherit gog-games

DESCRIPTION="DEFCON"
HOMEPAGE="https://www.gog.com/game/defcon"

SRC_URI="gog_defcon_2.0.0.5.sh"

KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"

RDEPEND="!bundled-libs? ( media-libs/libogg
				media-libs/libsdl
				media-libs/libvorbis
				virtual/glu
				virtual/opengl )"

DEPEND=""

game_require_serial_key=1
gog_pn="defcon"

src_install() {
	if use bundled-libs; then
		use amd64 || rm -rf lib64 || die
		use x86 || rm -rf lib || die
	else
		rm -rf lib lib64 || die
	fi

	use amd64 || rm defcon.bin.x86_64 || die
	use x86 || rm defcon.bin.x86 || die

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/defcon.png" . || die

	use amd64 && games_make_wrapper "${PN}" ./defcon.bin.x86_64 "${dir}"
	use x86 && games_make_wrapper "${PN}" ./defcon.bin.x86 "${dir}"
	newicon defcon.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}

	prepgamesdirs
}
