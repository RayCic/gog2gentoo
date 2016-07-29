# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

gog_pn="grim_fandango_remastered"

CHECKREQS_DISK_BUILD=6G

inherit gog-games

DESCRIPTION="Grim Fandango Remastered"

SRC_URI="gog_grim_fandango_remastered_2.3.0.7.sh
	savedir-patch? ( Unofficial-GOG-Linux-Grim-Fandango-SaveDir-Patch-v2.xdelta3 )"

KEYWORDS="-* ~amd64 ~x86"
IUSE="+bundled-libs savedir-patch"

RDEPEND="!bundled-libs? ( =media-libs/libsdl2-2.0*[abi_x86_32(-)] )
	x11-libs/libX11[abi_x86_32(-)]
	virtual/glu[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]"

DEPEND="savedir-patch? ( dev-util/xdelta:3 )"

src_install() {
	# delete Steam Linux Runtime (why it is included???)
	rm -rf bin/i386 bin/amd64 bin/scripts || die

	# delete licenses - we already have them in portage
	rm -rf bin/common-licenses || die

	if use savedir-patch ; then
		xdelta3 -d -s bin/GrimFandango "${DISTDIR}/Unofficial-GOG-Linux-Grim-Fandango-SaveDir-Patch-v2.xdelta3" bin/GrimFandango.new
		mv bin/GrimFandango.new bin/GrimFandango || die
		chmod 0755 bin/GrimFandango
	fi

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv bin/* "${D}${dir}" || die
	cp "${D}${dir}/icon.png" . || die

	# dirty hack
	if ! use bundled-libs ; then
		use amd64 || ln -sf "/usr/lib32/libSDL2-2.0.so.0"  "${D}${dir}/libSDL2-2.0.so.1"|| die
		use x86 || ln -sf "/usr/lib/libSDL2-2.0.so.0"  "${D}${dir}/libSDL2-2.0.so.1"|| die
	fi

	games_make_wrapper "${PN}" ./GrimFandango "${dir}"
	newicon icon.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}

	prepgamesdirs
}

pkg_postinst() {
	gog-games_pkg_postinst

	use bundled-libs || ewarn "Warning! You disabled 'bundled-libs' flag."
	use bundled-libs || ewarn "For this game this configuration is not supported."
	use bundled-libs || ewarn "Use at your own risk."

	if use savedir-patch ; then
		ewarn "Warning! You enabled 'savedir-patch' flag."
		ewarn "Because in this configuration game's executable is modified"
		ewarn "this configuration may be illegal in some countries"
		ewarn "Consult your lawyer."
	else
		ewarn "Warning! 'savedir-patch' flag is not enabled."
		ewarn "Saving configuration and save games will not work."
	fi
}

pkg_nofetch() {
	gog-games_pkg_nofetch()

	if use savedir-patch; then
		einfo
		einfo "Please download following file:"
		einfo "https://github.com/RayCic/uglgfsp/raw/master/Unofficial-GOG-Linux-Grim-Fandango-SaveDir-Patch-v2.xdelta3"
		einfo "and move it to ${DISTDIR}"
	fi
}
