# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

gog_pn="darkest_dungeon"

CHECKREQS_DISK_BUILD=3G

inherit gog-games-2

DESCRIPTION="Darkest Dungeon"
HOMEPAGE="https://www.gog.com/game/darkest_dungeon"

SRC_URI="darkest_dungeon_en_21142_16140.sh
	dlc-tcc? ( darkest_dungeon_the_crimson_court_dlc_en_21096_16065.sh )
	dlc-tsb? ( darkest_dungeon_the_shieldbreaker_dlc_en_21142_16140.sh )"

KEYWORDS="-* ~amd64 ~x86"

IUSE="alsa bundled-libs dlc-tcc dlc-tsb pulseaudio"
REQUIRED_USE="|| ( alsa pulseaudio )"

RDEPEND="!bundled-libs? ( media-libs/libsdl2[X,video,sound,opengl,joystick,haptic,alsa?,pulseaudio?] )
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	virtual/opengl"

DEPEND=""

QA_PREBUILT="${dir:1}/lib/libfmod.so.6 ${dir:1}/lib64/libfmod.so.6"

src_install() {
	use bundled-libs || rm lib/libSDL2-2.0.so.0 lib64/libSDL2-2.0.so.0 || die

	use amd64 || rm -rf lib64 darkest.bin.x86_64 || die
	use x86 || rm -rf lib darkest.bin.x86 || die

	# Fix folders' permissions
	find . -type d -exec chmod 0755 {} \;

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/Icon.bmp" . || die

	use amd64 && make_wrapper "${PN}" ./darkest.bin.x86_64 "${dir}"
	use x86 && make_wrapper "${PN}" ./darkest.bin.x86 "${dir}"
	newicon Icon.bmp "${PN}.bmp"
	make_desktop_entry "${PN}" "${DESCRIPTION}" "/usr/share/pixmaps/${PN}.bmp"
}
