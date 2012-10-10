# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit versionator eutils toolchain-funcs flag-o-matic

MY_PV="${PV//./}"
MY_P="${PN}${MY_PV}"

DESCRIPTION="Advanced file encryption using AES"
HOMEPAGE="http://www.aescrypt.com/"
SRC_URI="http://www.aescrypt.com/cgi-bin/download?file=v$(get_major_version)/${MY_P}_source.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}_source"

src_prepare() {
	epatch "${FILESDIR}/${P}-build.patch"
	epatch "${FILESDIR}/${P}-iconv.patch"
}

src_compile() {
	if use static; then
		append-cflags "-DDISABLE_ICONV"
		append-ldflags "-static"
	fi
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)"
}
