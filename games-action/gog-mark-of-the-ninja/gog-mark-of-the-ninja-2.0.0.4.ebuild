# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

gog_pn="mark_of_the_ninja"

CHECKREQS_DISK_BUILD=2500M

inherit gog-games-2

DESCRIPTION="Mark of the Ninja"

SRC_URI="gog_mark_of_the_ninja_2.0.0.4.sh
	dlc? ( gog_mark_of_the_ninja_special_edition_dlc_2.0.0.4.sh )"

KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs dlc"

RDEPEND="!bundled-libs? ( media-libs/libsdl[X,opengl,video,sound] )
	virtual/opengl"

DEPEND="app-admin/chrpath"

src_install() {
	# Fix library files duplication
	ln -sf libfmodevent64-4.44.14.so bin/lib64/libfmodevent64.so || die
	ln -sf libfmodex64-4.44.14.so bin/lib64/libfmodex64.so || die
	ln -sf libfmodevent-4.44.14.so bin/lib32/libfmodevent.so || die
	ln -sf libfmodex-4.44.14.so bin/lib32/libfmodex.so || die
	ln -sf libSDL-1.2.so.0.11.4 bin/lib32/libSDL-1.2.so.0 || die
	ln -sf libSDL-1.2.so.0.11.4 bin/lib32/libSDL-1.2.so || die
	ln -sf libSDL-1.2.so.0.11.4 bin/lib32/libSDL.so || die
	ln -sf libSDL-1.2.so.0.11.4 bin/lib64/libSDL-1.2.so.0 || die
	ln -sf libSDL-1.2.so.0.11.4 bin/lib64/libSDL-1.2.so || die
	ln -sf libSDL-1.2.so.0.11.4 bin/lib64/libSDL.so || die

	# Fix security warnings
	chrpath --replace '$ORIGIN/lib32' bin/ninja-bin32 || die
	chrpath --replace '$ORIGIN/lib64' bin/ninja-bin64 || die

	use bundled-libs || rm bin/lib32/libSDL* bin/lib64/libSDL* || die

	use amd64 || rm -rf bin/lib64 bin/ninja-bin64 || die
	use x86 || rm -rf bin/lib32 bin/ninja-bin32 || die

	rm bin/ninja-bin

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/bin/motn_icon.xpm" . || die

	use amd64 && make_wrapper "${PN}" ./ninja-bin64 "${dir}/bin"
	use x86 && make_wrapper "${PN}" ./ninja-bin32 "${dir}/bin"
	newicon motn_icon.xpm "${PN}.xpm"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}
}

pkg_nofetch() {
	if use dlc; then
		einfo "Please download gog_mark_of_the_ninja_2.0.0.4.sh and gog_mark_of_the_ninja_special_edition_dlc_2.0.0.4.sh"
		einfo "from your GOG.com account after buying '${DESCRIPTION} SPECIAL EDITION' or"
		einfo "'${DESCRIPTION}' + '${DESCRIPTION} SPECIAL EDITION UPGRADE'"
		einfo "and put it into ${DISTDIR}."
		einfo
		einfo "You can download gog_mark_of_the_ninja_2.0.0.4.sh and gog_mark_of_the_ninja_special_edition_dlc_2.0.0.4.sh in two ways:"
		einfo "   1) by internet browser"
		einfo "      a) open page 'https://www.gog.com/'"
		einfo "      b) login into your account"
		einfo "      c) go to 'Library' section"
		einfo "      d) select '${DESCRIPTION}'"
		einfo "      e) chose 'OS: Linux' and 'Language: Englih' (Linux version of archive contains all supported languages)"
		einfo "      f) download '${DESCRIPTION}' and 'Special Edition Upgrade'"
		einfo "   2) by programm 'lgogdownloader'"
		einfo "      a) install 'games-util/lgogdownloader': emerge games-util/lgogdownloader"
		einfo "      b) go to temporary directory"
		einfo "      c) run: lgogdownloader --download --game ${gog_pn} --platform linux --include installers,dlc"
		einfo "      d) enter login information"
		einfo
		einfo "And do not forget to move gog_mark_of_the_ninja_2.0.0.4.sh and gog_mark_of_the_ninja_special_edition_dlc_2.0.0.4.sh to ${DISTDIR}"
	else
		einfo "Please download gog_mark_of_the_ninja_2.0.0.4.sh from your GOG.com account after buying '${DESCRIPTION}'"
		einfo "and put it into ${DISTDIR}."
		einfo
		einfo "You can download gog_mark_of_the_ninja_2.0.0.4.sh in two ways:"
		einfo "   1) by internet browser"
		einfo "      a) open page 'https://www.gog.com/'"
		einfo "      b) login into your account"
		einfo "      c) go to 'Library' section"
		einfo "      d) select '${DESCRIPTION}'"
		einfo "      e) chose 'OS: Linux' and 'Language: Englih' (Linux version of archive contains all supported languages)"
		einfo "      f) in file list click on '${DESCRIPTION}'"
		einfo "   2) by programm 'lgogdownloader'"
		einfo "      a) install 'games-util/lgogdownloader': emerge games-util/lgogdownloader"
		einfo "      b) go to temporary directory"
		einfo "      c) run: lgogdownloader --download --game ${gog_pn} --platform linux --include installers"
		einfo "      d) enter login information"
		einfo
		einfo "And do not forget to move gog_mark_of_the_ninja_2.0.0.4.sh to ${DISTDIR}"
	fi
}
