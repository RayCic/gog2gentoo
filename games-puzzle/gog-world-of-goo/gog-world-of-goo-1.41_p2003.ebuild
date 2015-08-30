# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO:
# - find out all required use flags for dependencies
# - find out all licenses on which package depends

EAPI="5"

CHECKREQS_DISK_BUILD=80M

inherit gog-games

DESCRIPTION="World of Goo"
HOMEPAGE="https://www.gog.com/game/world_of_goo"

SRC_URI="gog_world_of_goo_2.0.0.3.sh"

KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"

RDEPEND="!bundled-libs? ( media-libs/libsdl
			media-libs/sdl-mixer
			media-libs/libogg )"

DEPEND=""

gog_pn="world_of_goo"

src_install() {
	use bundled-libs || rm -rf libs32 libs64 || die

	use amd64 || rm -rf libs64 WorldOfGoo.bin64 || die
	use x86 || rm -rf libs32 WorldOfGoo.bin32 || die

	rm WorldOfGoo

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/icons/scalable.svg" . || die

	if use bundled-libs; then
		use amd64 && games_make_wrapper "${PN}" ./WorldOfGoo.bin64 "${dir}" "./libs64"
		use x86 && games_make_wrapper "${PN}" ./WorldOfGoo.bin32 "${dir}" "./libs32"
	else
		use amd64 && games_make_wrapper "${PN}" ./WorldOfGoo.bin64 "${dir}"
		use x86 && games_make_wrapper "${PN}" ./WorldOfGoo.bin32 "${dir}"
	fi
	newicon scalable.svg "${PN}.svg"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}

	prepgamesdirs
}
