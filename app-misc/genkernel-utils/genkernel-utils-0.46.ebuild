# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Gentoo's genkernel utilities"
HOMEPAGE="http://alon.barlev.googlepages.com/utilities"
SRC_URI="http://github.com/downloads/alonbl/genkernel-utils/${P}.tar.bz2"
SRC_URI="https://github.com/alonbl/${PN}/archive/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="fbsplash"

DEPEND=""
RDEPEND=">=sys-kernel/genkernel-3.4.21
	fbsplash? ( >=media-gfx/splashutils-1.5.1 )"

S="${WORKDIR}/${PN}-${P}"

src_install() {
	default
	dodoc examples/*
	dodir /var/lib/genkernel-utils
	dodir /var/lib/genkernel-utils/files
}
