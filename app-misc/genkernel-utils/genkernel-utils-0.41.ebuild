# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Gentoo's genkernel utilities"
HOMEPAGE="http://alon.barlev.googlepages.com/utilities"
SRC_URI="http://alon.barlev.googlepages.com/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="fbsplash"

DEPEND=""
RDEPEND=">=sys-kernel/genkernel-3.4.10_pre7
	fbsplash? ( >=media-gfx/splashutils-1.5.1 )"

src_install() {
	make install DESTDIR="${D}" || die
	dodoc LICENSE
	dodoc README
	dodoc examples/*
	dodir /var/lib/genkernel-utils
	dodir /var/lib/genkernel-utils/files
}

