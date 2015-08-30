# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO:
# - find out all required use flags for dependencies
# - find out all licenses on which package depends

EAPI="5"

CHECKREQS_DISK_BUILD=35G

inherit gog-games

DESCRIPTION="The Witcher 2: Assassins Of Kings - Enhanced Edition"
HOMEPAGE="https://www.gog.com/game/the_witcher_2"

SRC_URI="gog_the_witcher_2_assassins_of_kings_enhanced_edition_2.2.0.8.sh"

KEYWORDS="-* ~amd64 ~x86"

RDEPEND="media-libs/libsdl2[abi_x86_32(-)]
	media-libs/sdl2-image[abi_x86_32(-)]
	x11-libs/gtk+:2[abi_x86_32(-)]
	media-libs/freetype[abi_x86_32(-)]"

DEPEND=""

gog_pn="the_witcher_2"

src_install() {
	cat CookedPC/pack0.dzip.split* > CookedPC/pack0.dzip || die
	rm CookedPC/pack0.dzip.split* || die

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/linux/icons/witcher2-icon.png" . || die

	games_make_wrapper "${PN}" ./launcher "${dir}"
	newicon witcher2-icon.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}

	prepgamesdirs
}
