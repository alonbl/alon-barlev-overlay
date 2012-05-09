# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/openvpn/openvpn-9999.ebuild,v 1.2 2012/03/01 12:10:51 djc Exp $

EAPI=4

DESCRIPTION="Down root plugin for OpenVPN."
HOMEPAGE="http://openvpn.net/"

if [[ "${PV}" = 9999 ]]; then
	inherit git-2 autotools
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/alonbl/${PN}.git"
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-linux"
	SRC_URI="http://swupdate.openvpn.net/community/releases/${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=net-misc/openvpn-2.3_alpha[-minimal]
	sys-libs/pam"
RDEPEND="${DEPEND}"

src_prepare() {
	[ "${PV}" = 9999 ] && eautoreconf
}

src_configure() {
	econf ${myconf} \
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
}

src_install() {
	emake DESTDIR="${D}" install

	# install documentation
	dodoc README
}

pkg_postinst() {
	einfo "plugins have been installed into /usr/$(get_libdir)/openvpn"

	if [[ ${PV} == "9999" ]]; then
		ewarn ""
		ewarn "You are using a live ebuild building from the sources of openvpn"
		ewarn "repository from http://openvpn.git.sourceforge.net. For reporting"
		ewarn "bugs please contact: openvpn-devel@lists.sourceforge.net"
	fi
}
