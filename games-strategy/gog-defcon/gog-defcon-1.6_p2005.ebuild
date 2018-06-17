# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

gog_pn="defcon"

CHECKREQS_DISK_BUILD=70M

inherit gog-games-2

DESCRIPTION="DEFCON"

SRC_URI="gog_defcon_2.0.0.5.sh"

KEYWORDS="-* ~amd64 ~x86"

IUSE="bundled-libs alsa nas oss pulseaudio"
REQUIRED_USE="|| ( alsa nas oss pulseaudio )"

RDEPEND="!bundled-libs? ( media-libs/libogg
				media-libs/libsdl[X,alsa?,nas?,opengl,oss?,pulseaudio?,sound,video]
				virtual/glu )
	bundled-libs? ( alsa? ( media-libs/alsa-lib )
			nas? ( media-libs/nas )
			pulseaudio? ( media-sound/pulseaudio ) )
	virtual/opengl
	media-libs/libvorbis"

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

	use amd64 || rm defcon.bin.x86_64 || die
	use x86 || rm defcon.bin.x86 || die

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/defcon.png" . || die

	use amd64 && make_wrapper "${PN}" ./defcon.bin.x86_64 "${dir}"
	use x86 && make_wrapper "${PN}" ./defcon.bin.x86 "${dir}"
	newicon defcon.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}
}
