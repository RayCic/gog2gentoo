# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO:
# - find out all required use flags for dependencies
# - find out all licenses on which package depends

EAPI="5"

CHECKREQS_DISK_BUILD=500M

inherit gog-games

DESCRIPTION="A Golden Wake"
HOMEPAGE="https://www.gog.com/game/a_golden_wake"

SRC_URI="gog_a_golden_wake_2.0.0.4.sh"

KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"

RDEPEND="!bundled-libs? ( media-libs/libsdl2
				media-libs/libtheora
				media-libs/libvorbis
				media-libs/libogg )"

DEPEND=""

gog_pn="a_golden_wake"

src_install() {
	if use bundled-libs; then
		use amd64 || rm -rf lib64 || die
		use x86 || rm -rf lib || die
	else
		rm -rf lib lib64 || die
	fi

	use amd64 || rm A_Golden_Wake.bin.x86_64 || die
	use x86 || rm A_Golden_Wake.bin.x86 || die

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/GoldenWake.png" . || die

	use amd64 && games_make_wrapper "${PN}" ./A_Golden_Wake.bin.x86_64 "${dir}"
	use x86 && games_make_wrapper "${PN}" ./A_Golden_Wake.bin.x86 "${dir}"
	newicon GoldenWake.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}

	prepgamesdirs
}