# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

gog_pn="uplink_hacker_elite"

CHECKREQS_DISK_BUILD=50M

inherit gog-games

DESCRIPTION="Uplink: Hacker Elite"

SRC_URI="gog_uplink_hacker_elite_2.0.0.4.sh"

KEYWORDS="-* ~amd64 ~x86"

IUSE="bundled-libs alsa nas oss pulseaudio"
REQUIRED_USE="|| ( alsa nas oss pulseaudio )"

# - for media-libs/sdl-mixer 'modplug' flag causes strange noises instead of music
# - media-libs/libmikmod is not direct dependency but we include it to enforce same
#    sound system configuration
RDEPEND="!bundled-libs? ( media-libs/freetype
				media-libs/libsdl[X,opengl,video,sound,alsa?,nas?,oss?,pulseaudio?]
				media-libs/sdl-mixer[mikmod,mod,-modplug]
				media-libs/libmikmod[alsa?,nas?,oss?,pulseaudio?]
				media-libs/tiff:3
				sys-libs/zlib
				virtual/glu
				virtual/jpeg:62 )
	bundled-libs? ( alsa? ( media-libs/alsa-lib )
			nas? ( media-libs/nas )
			pulseaudio? ( media-sound/pulseaudio ) )
	virtual/opengl"

DEPEND=""

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
