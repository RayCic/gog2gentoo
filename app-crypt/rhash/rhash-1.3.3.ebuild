# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PLOCALES="de en_AU es gl it ru"

inherit l10n eutils

MY_PN="RHash"

DESCRIPTION="Great utility for computing hash sums"
HOMEPAGE="http://rhash.anz.ru/"
SRC_URI="https://github.com/rhash/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_PN}-${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug nls openssl static-libs"

DEPEND="nls? ( sys-devel/gettext )
	openssl? ( dev-libs/openssl:* )"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}-${PV}

src_prepare() {
	l10n_find_plocales_changes "po" "" ".po"

	rm_po() {
		rm po/$1.po || die
	}
	l10n_for_each_disabled_locale_do rm_po
}

src_compile() {
	local MYDEBUG=""
	local ADDCFLAGS=""
	local ADDLDFLAGS=""

	use debug || MYDEBUG="${MYDEBUG} -DNDEBUG"
	use nls && ADDCFLAGS="${ADDCFLAGS} -DUSE_GETTEXT"
	use openssl && ADDCFLAGS="${ADDCFLAGS} -DOPENSSL_RUNTIME -rdynamic" && ADDLDFLAGS="${ADDLDFLAGS} -ldl"

	emake CFLAGS="${CFLAGS} ${MYDEBUG}" ADDCFLAGS="${ADDCFLAGS}" ADDLDFLAGS="${ADDLDFLAGS}" build-shared lib-static || die
}

src_install() {
	local MYPARAMS=""

	use nls && MYPARAMS="${MYPARAMS} install-gmo"

	emake install-shared install-lib-static install-lib-shared ${MYPARAMS} PREFIX=/usr DESTDIR="${D}" LIBDIR=/usr/$(get_libdir)

	use static-libs || rm "${D}"/usr/$(get_libdir)/librhash.a || die
}
