# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

gog_pn="multiwinia"

CHECKREQS_DISK_BUILD=70M

inherit gog-games

DESCRIPTION="Multiwinia"

SRC_URI="gog_multiwinia_2.0.0.5.sh"

KEYWORDS="-* ~amd64 ~x86"

IUSE="bundled-libs alsa nas oss pulseaudio"
REQUIRED_USE="|| ( alsa nas oss pulseaudio )"

RDEPEND="!bundled-libs? ( media-libs/libogg
				media-libs/libpng:1.2
				media-libs/libsdl[X,opengl,video,sound,alsa?,nas?,oss?,pulseaudio?]
				media-libs/openal[alsa?,oss?,pulseaudio?]
				sys-libs/zlib
				virtual/glu )
	bundled-libs? ( alsa? ( media-libs/alsa-lib )
			nas? ( media-libs/nas )
			pulseaudio? ( media-sound/pulseaudio ) )
	media-libs/libvorbis
	virtual/opengl"

DEPEND=""

game_require_serial_key=1

src_install() {
	if use bundled-libs; then
		# GOG installer contains only half of libvorbis library
		# To prevent library files mismatch we delete bundled libvorbis files
		rm lib/libvorbis.so* lib64/libvorbis.so* || die

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

pkg_postinst() {
	gog-games_pkg_postinst

	use nas && elog "Warning! You chose 'nas' USE flag. NAS audio system is not supported by OpenAL library."
	use nas && elog "If you really use NAS audio system as primary audio system, then do not select OpenAL"
	use nas && elog "driver in the game's sound driver options or you do not get any sound"
}