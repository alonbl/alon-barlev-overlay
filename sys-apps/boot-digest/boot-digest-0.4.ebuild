# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Boot-digest utilities"
HOMEPAGE="http://alon.barlev.googlepages.com/pkcs11-utilities"
SRC_URI="http://alon.barlev.googlepages.com/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""

DEPEND=""
RDEPEND="
	dev-lang/perl
	virtual/perl-Digest-SHA
"

src_compile() {
	econf --digest=SHA-512
	emake
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc LICENSE
	dodoc README.wiki
	newinitd ${FILESDIR}/boot-digest-check.init boot-digest-check
}

pkg_postinst() {
	einfo "Please add boot-digest-check to boot runlevel"
}
