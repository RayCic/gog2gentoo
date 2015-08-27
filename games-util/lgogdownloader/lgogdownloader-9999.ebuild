# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils git-r3

DESCRIPTION="Linux compatible gog.com downloader"
HOMEPAGE="https://sites.google.com/site/gogdownloader/"
EGIT_REPO_URI="https://github.com/Sude-/lgogdownloader.git"

LICENSE="WTFPL"
SLOT="0"

DEPEND="dev-libs/jsoncpp
	net-libs/liboauth
	net-misc/curl
	dev-libs/boost
	dev-libs/tinyxml
	app-crypt/rhash
	net-libs/htmlcxx"

RDEPEND="${DEPEND}"
