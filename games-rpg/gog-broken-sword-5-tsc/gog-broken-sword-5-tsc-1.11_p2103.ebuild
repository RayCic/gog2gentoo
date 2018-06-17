# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

gog_pn="broken_sword_5_the_serpents_curse_episode_1"

CHECKREQS_DISK_BUILD=7G

inherit gog-games-2

DESCRIPTION="Broken Sword 5 - The Serpent's Curse"
HOMEPAGE="https://www.gog.com/game/broken_sword_5_the_serpents_curse"

SRC_URI="gog_broken_sword_5_the_serpent_s_curse_2.1.0.3.sh"

KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"

RDEPEND="!bundled-libs? ( media-libs/openal )
	bundled-libs? ( || ( media-libs/alsa-lib media-sound/pulseaudio ) )
	x11-libs/libXcursor
	x11-libs/libXinerama
	x11-libs/libXi
	x11-libs/libXrandr
	virtual/opengl"

DEPEND=""

src_install() {
	use bundled-libs || rm -rf i386/libopenal.so.1 x86_64/libopenal.so.1 || die

	use amd64 || rm -rf x86_64 || die
	use x86 || rm -rf i386 || die

	rm BS5 || die

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/icon.bmp" . || die

	use amd64 && make_wrapper "${PN}" ./x86_64/BS5_x86_64 "${dir}"
	use x86 && make_wrapper "${PN}" ./i386/BS5_i386 "${dir}"
	newicon icon.bmp "${PN}.bmp"
	make_desktop_entry "${PN}" "${DESCRIPTION}" "/usr/share/pixmaps/${PN}.bmp"
}
