# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO:
# - find out all required use flags for dependencies
# - find out all licenses on which package depends

EAPI="5"

CHECKREQS_DISK_BUILD=70M

inherit gog-games

DESCRIPTION="Multiwinia"
HOMEPAGE="https://www.gog.com/game/multiwinia"

SRC_URI="gog_multiwinia_2.0.0.5.sh"

KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"

RDEPEND="!bundled-libs? ( virtual/glu
			media-libs/libsdl
			media-libs/libogg
			media-libs/libvorbis
			media-libs/openal
			media-libs/libpng:1.2
			sys-libs/zlib )"

DEPEND=""

game_require_serial_key=1

gog_pn="multiwinia"

src_install() {
	if use bundled-libs; then
		use amd64 || rm -rf lib64 || die
		use x86 || rm -rf lib || die
	else
		rm -rf lib lib64 || die
	fi

	use amd64 || rm multiwinia.bin.x86_64 || die
	use x86 || rm multiwinia.bin.x86 || die

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/multiwinia.png" . || die

	use amd64 && games_make_wrapper "${PN}" ./multiwinia.bin.x86_64 "${dir}"
	use x86 && games_make_wrapper "${PN}" ./multiwinia.bin.x86 "${dir}"
	newicon multiwinia.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}

	prepgamesdirs
}
