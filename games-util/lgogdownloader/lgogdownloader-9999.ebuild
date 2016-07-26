# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

CMAKE_MIN_VERSION="3.0.0"

inherit cmake-utils git-r3

DESCRIPTION="Linux compatible gog.com downloader"
HOMEPAGE="https://sites.google.com/site/gogdownloader/"
EGIT_REPO_URI="https://github.com/Sude-/lgogdownloader.git"

LICENSE="WTFPL-2"
SLOT="0"
IUSE="+debug"

RDEPEND="dev-libs/jsoncpp
	net-libs/liboauth
	dev-libs/boost
	dev-libs/tinyxml2
	app-crypt/rhash
	net-libs/htmlcxx
	>=net-misc/curl-7.32.0"

DEPEND="${RDEPEND}
	sys-apps/help2man
	sys-apps/grep"
