# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Boot-digest utilities"
HOMEPAGE="http://alon.barlev.googlepages.com/pkcs11-utilities"
SRC_URI="https://github.com/alonbl/${PN}/archive/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""

DEPEND=""
RDEPEND="sys-apps/coreutils"

S="${WORKDIR}/${PN}-${P}"

src_install() {
	make install DESTDIR="${D}" || die
	newinitd "${FILESDIR}/boot-digest-check.init boot-digest-check"
}

pkg_postinst() {
	einfo "Please add boot-digest-check to boot runlevel"
}
