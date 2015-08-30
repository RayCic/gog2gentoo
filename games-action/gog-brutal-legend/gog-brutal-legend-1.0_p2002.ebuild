# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO:
# - find out all required use flags for dependencies
# - find out all licenses on which package depends

EAPI="5"

CHECKREQS_DISK_BUILD=9G

inherit gog-games

DESCRIPTION="Brutal Legend"
HOMEPAGE="https://www.gog.com/game/brutal_legend"

SRC_URI="gog_brutal_legend_2.0.0.2.sh"

KEYWORDS="-* ~amd64 ~x86"

IUSE="bundled-libs"

RDEPEND="!bundled-libs? ( media-libs/libsdl2[abi_x86_32(-)] )"

DEPEND=""

gog_pn="brutal_legend"

src_install() {
	use bundled-libs || rm -rf lib/libSDL2-2.0.so.0 || die

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/Buddha.png" . || die

	games_make_wrapper "${PN}" ./Buddha.bin.x86 "${dir}"
	newicon Buddha.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}

	prepgamesdirs
}
