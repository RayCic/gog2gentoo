# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

gog_pn="brutal_legend"

CHECKREQS_DISK_BUILD=9G

inherit gog-games-2

DESCRIPTION="Brutal Legend"

SRC_URI="gog_brutal_legend_2.0.0.3.sh"

KEYWORDS="-* ~amd64 ~x86"

IUSE="bundled-libs"

RDEPEND="!bundled-libs? ( media-libs/libsdl2[X,opengl,video,sound,abi_x86_32(-)] )
	sys-libs/zlib[abi_x86_32(-)]
	virtual/glu[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]"

DEPEND="media-libs/libpng"

QA_PREBUILT="${dir:1}/Buddha.bin.x86"

src_install() {
	use bundled-libs || rm -rf lib/libSDL2-2.0.so.0 || die

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die

	pngfix --quiet --out=Buddha.png "${D}${dir}/Buddha.png"
	cp --force Buddha.png "${D}${dir}/Buddha.png" || die "pngfix failed"

	make_wrapper "${PN}" ./Buddha.bin.x86 "${dir}"
	newicon Buddha.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}
}
