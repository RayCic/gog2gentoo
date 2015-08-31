# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO:
# - find out all required use flags for dependencies
# - find out all licenses on which package depends

EAPI="5"

CHECKREQS_DISK_BUILD=50M

inherit gog-games

DESCRIPTION="Uplink: Hacker Elite"
HOMEPAGE="https://www.gog.com/game/uplink_hacker_elite"

SRC_URI="gog_uplink_hacker_elite_2.0.0.4.sh"

KEYWORDS="-* ~amd64 ~x86"

IUSE="bundled-libs alsa nas oss pulseaudio"
REQUIRED_USE="|| ( alsa nas oss pulseaudio )"

RDEPEND="!bundled-libs? ( media-libs/freetype
				media-libs/libsdl[X,opengl,video,sound,alsa?,nas?,oss?,pulseaudio?]
				media-libs/sdl-mixer
				media-libs/tiff:3
				sys-libs/zlib
				virtual/glu
				virtual/jpeg:62 )
	bundled-libs? ( alsa? ( media-libs/alsa-lib )
			nas? ( media-libs/nas )
			pulseaudio? ( media-sound/pulseaudio ) )
	virtual/opengl"

DEPEND=""

gog_pn="uplink_hacker_elite"

src_install() {
	if use bundled-libs; then
		use amd64 || rm -rf lib64 || die
		use x86 || rm -rf lib || die
	else
		rm -rf lib lib64 || die
	fi

	use amd64 || rm uplink.bin.x86_64 || die
	use x86 || rm uplink.bin.x86 || die

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/uplink.png" . || die

	use amd64 && games_make_wrapper "${PN}" ./uplink.bin.x86_64 "${dir}"
	use x86 && games_make_wrapper "${PN}" ./uplink.bin.x86 "${dir}"
	newicon uplink.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}

	prepgamesdirs
}
