# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Read the one time password from RSA SecurID SID800 device"
HOMEPAGE="https://github.com/alonbl/RSA_SecureID_getpasswd_openct"
SRC_URI="https://github.com/downloads/alonbl/${PN}/${P,,}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/openct"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${P,,}"
