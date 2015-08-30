# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO:
# - find out all required use flags for dependencies
# - find out all licenses on which package depends

EAPI="5"

CHECKREQS_DISK_BUILD=50M

inherit gog-games

DESCRIPTION="Darwinia"
HOMEPAGE="https://www.gog.com/game/darwinia"

SRC_URI="gog_darwinia_2.0.0.5.sh"

KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"

RDEPEND="!bundled-libs? ( virtual/glu
			media-libs/libsdl
			media-libs/libogg
			media-libs/libvorbis )"

DEPEND=""

gog_pn="darwinia"

src_install() {
	if use bundled-libs; then
		use amd64 || rm -rf lib64 || die
		use x86 || rm -rf lib || die
	else
		rm -rf lib lib64 || die
	fi

	use amd64 || rm darwinia.bin.x86_64 || die
	use x86 || rm darwinia.bin.x86 || die

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/darwinian.png" . || die

	use amd64 && games_make_wrapper "${PN}" ./darwinia.bin.x86_64 "${dir}"
	use x86 && games_make_wrapper "${PN}" ./darwinia.bin.x86 "${dir}"
	newicon darwinian.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}

	prepgamesdirs
}