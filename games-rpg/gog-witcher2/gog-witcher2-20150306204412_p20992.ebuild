# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

gog_pn="the_witcher_2"

CHECKREQS_DISK_BUILD=28G

inherit gog-games-2

DESCRIPTION="The Witcher 2: Assassins Of Kings - Enhanced Edition"

SRC_URI="the_witcher_2_assassins_of_kings_enhanced_edition_en_release_3_20150306204412_20992.sh"

KEYWORDS="-* ~amd64 ~x86"

IUSE="crash-reporter"

RDEPEND="dev-libs/glib:2[abi_x86_32(-)]
	media-libs/freetype[abi_x86_32(-)]
	media-libs/libsdl2[X,haptic,joystick,opengl,sound,threads,video,udev,abi_x86_32(-)]
	media-libs/sdl2-image[png,abi_x86_32(-)]
	media-libs/sdl2-ttf[abi_x86_32(-)]
	media-libs/freetype[abi_x86_32(-)]
	media-libs/alsa-lib[abi_x86_32(-)]
	media-plugins/alsa-plugins[abi_x86_32(-)]
	net-misc/curl[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/cairo[abi_x86_32(-)]
	x11-libs/gdk-pixbuf:2[abi_x86_32(-)]
	x11-libs/gtk+:2[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	crash-reporter? ( x11-libs/gtk+:3
				>=sys-devel/gcc-4.9 )"

DEPEND=""

src_install() {
	cat CookedPC/pack0.dzip.split01 >> CookedPC/pack0.dzip.split00 || die
	rm CookedPC/pack0.dzip.split01 || die
	cat CookedPC/pack0.dzip.split02 >> CookedPC/pack0.dzip.split00 || die
	rm CookedPC/pack0.dzip.split02 || die
	mv CookedPC/pack0.dzip.split00 CookedPC/pack0.dzip

	use crash-reporter || rm CrashReporter* || die

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/linux/icons/witcher2-icon.png" . || die

	make_wrapper "${PN}" ./launcher "${dir}"
	newicon witcher2-icon.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}
}
