# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

gog_pn="amnesia_a_machine_for_pigs"

CHECKREQS_DISK_BUILD=5500M

inherit gog-games

DESCRIPTION="Amnesia: A Machine For Pigs"

SRC_URI="gog_amnesia_a_machine_for_pigs_2.0.0.2.sh"

KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"

RDEPEND="!bundled-libs? ( media-libs/devil
				media-libs/fontconfig
				media-libs/libogg
				media-libs/libsdl2
				media-libs/libtheora
				media-libs/libvorbis
				media-libs/openal
				sys-libs/zlib
				virtual/glu
				virtual/opengl
				x11-libs/libX11
				x11-libs/libXext
				x11-libs/libXft )"

DEPEND=""

src_install() {
	if use bundled-libs; then
		use amd64 || rm -rf lib64 || die
		use x86 || rm -rf lib || die
	else
		rm -rf lib lib64 || die
	fi

	chmod 0750 AmnesiaAMFP.bin.x86 Launcher.bin.x86 AmnesiaAMFP.bin.x86_64 Launcher.bin.x86_64

	use amd64 || rm AmnesiaAMFP.bin.x86_64 Launcher.bin.x86_64 || die
	use x86 || rm AmnesiaAMFP.bin.x86 Launcher.bin.x86 || die

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/AmnesiaAMFP.png" . || die

	use amd64 && games_make_wrapper "${PN}" ./Launcher.bin.x86_64 "${dir}"
	use x86 && games_make_wrapper "${PN}" ./Launcher.bin.x86 "${dir}"
	newicon AmnesiaAMFP.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}

	prepgamesdirs
}
