# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

gog_pn="world_of_goo"

CHECKREQS_DISK_BUILD=80M

inherit gog-games-2

DESCRIPTION="World of Goo"

SRC_URI="gog_world_of_goo_2.0.0.3.sh"

KEYWORDS="-* ~amd64 ~x86"

IUSE="bundled-libs"

RDEPEND="!bundled-libs? ( media-libs/libsdl[X,opengl,video,sound]
				media-libs/sdl-mixer[vorbis] )
	bundled-libs? ( media-libs/libvorbis )
	virtual/glu
	virtual/opengl"

DEPEND=""

QA_PREBUILT="${dir:1}/WorldOfGoo.bin*"

src_install() {
	use bundled-libs || rm -rf libs32 libs64 || die

	use amd64 || rm -rf libs64 WorldOfGoo.bin64 || die
	use x86 || rm -rf libs32 WorldOfGoo.bin32 || die

	rm WorldOfGoo

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/icons/scalable.svg" . || die

	if use bundled-libs; then
		use amd64 && make_wrapper "${PN}" ./WorldOfGoo.bin64 "${dir}" "./libs64"
		use x86 && make_wrapper "${PN}" ./WorldOfGoo.bin32 "${dir}" "./libs32"
	else
		use amd64 && make_wrapper "${PN}" ./WorldOfGoo.bin64 "${dir}"
		use x86 && make_wrapper "${PN}" ./WorldOfGoo.bin32 "${dir}"
	fi
	newicon scalable.svg "${PN}.svg"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}
}
