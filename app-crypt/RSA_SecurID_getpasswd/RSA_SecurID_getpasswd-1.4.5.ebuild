# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

STUPID_NUM="3672"

DESCRIPTION="CCID's ${PN}"
HOMEPAGE="http://pcsclite.alioth.debian.org/ccid.html"
SRC_URI="http://alioth.debian.org/download.php/${STUPID_NUM}/ccid-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/ccid-${PV}"

src_compile() {
	cd contrib/RSA_SecurID
	emake
}

src_install() {
	cd contrib/RSA_SecurID
	dobin RSA_SecurID_getpasswd
	doman RSA_SecurID_getpasswd.1
}
