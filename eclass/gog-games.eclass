#0 Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: gog-games.eclass
# @MAINTAINER:
# Raimonds Cicans <ray@apollo.lv>
# @BLURB: Eclass for GOG games packages
# @DESCRIPTION:
# The gog-games eclass contains miscellaneous, useful functions for GOG games packages.
#

inherit check-reqs eutils games

case "${EAPI:-0}" in
	5)
		;;
	0|1|2|3|4)
		die "EAPI=\"${EAPI}\" is not supported anymore"
		;;
	*)
		die "EAPI=\"${EAPI}\" is not supported yet"
		;;
esac

LICENSE="GOG-EULA"

SLOT="0"

DEPEND="app-arch/unzip"

RESTRICT="bindist strip test fetch"

gog_s="data/noarch/game"
S="${WORKDIR}/${gog_s}"
dir=${GAMES_PREFIX_OPT}/${PN}

EXPORT_FUNCTIONS pkg_nofetch src_unpack

gog-games_pkg_nofetch() {
	einfo "Please download ${SRC_URI} from your GOG.com account after buying '${DESCRIPTION}'"
	einfo "and put it into ${DISTDIR}."
	einfo
	einfo "You can download ${SRC_URI} in two ways:"
	einfo "   1) by internet browser"
	einfo "      a) open page 'https://www.gog.com/'"
	einfo "      b) login into your account"
	einfo "      c) go to 'Library' section"
	einfo "      d) select 'Amnesia: The Dark Descent'"
	einfo "      e) chose 'OS: Linux' and 'Language: Englih' (Linux version of archive contains all supported languages)"
	einfo "      f) in file list click on '${DESCRIPTION}'"
	einfo "   2) by programm 'lgogdownloader'"
	einfo "      a) install 'games-util/lgogdownloader': emerge games-util/lgogdownloader"
	einfo "      b) go to temporary directory"
	einfo "      c) run: lgogdownloader --download --game ${gog_pn} --platform 4 --language 1 --no-extras --no-patches --no-language-packs --no-dlc"
	einfo "      d) enter login information"
	einfo
	einfo "And do not forget to move ${SRC_URI} to ${DISTDIR}"
}

gog-games_src_unpack() {
	unzip -qq "${DISTDIR}/${A}" "${gog_s}/*" 2>/dev/null
	[[ $? -gt 1 ]] && die "Unzip failed"
}
