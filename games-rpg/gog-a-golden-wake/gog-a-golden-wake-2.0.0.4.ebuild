# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

gog_pn="a_golden_wake"

CHECKREQS_DISK_BUILD=500M

inherit gog-games-2

DESCRIPTION="A Golden Wake"

SRC_URI="gog_a_golden_wake_2.0.0.4.sh"

KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"

RDEPEND="!bundled-libs? ( media-libs/libsdl2[X,video,sound,opengl]
				media-libs/libogg
				media-libs/libtheora
				media-libs/libvorbis )
	media-libs/freetype
	virtual/opengl"

DEPEND=""

src_install() {
	if use bundled-libs; then
		use amd64 || rm -rf lib64 || die
		use x86 || rm -rf lib || die
	else
		rm -rf lib lib64 || die
	fi

	use amd64 || rm A_Golden_Wake.bin.x86_64 || die
	use x86 || rm A_Golden_Wake.bin.x86 || die

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/GoldenWake.png" . || die

	use amd64 && make_wrapper "${PN}" ./A_Golden_Wake.bin.x86_64 "${dir}"
	use x86 && make_wrapper "${PN}" ./A_Golden_Wake.bin.x86 "${dir}"
	newicon GoldenWake.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}
}
