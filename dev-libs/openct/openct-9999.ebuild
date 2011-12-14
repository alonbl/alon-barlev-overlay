# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/openct/openct-0.6.14-r1.ebuild,v 1.1 2008/02/15 09:31:36 alonbl Exp $

inherit eutils

DESCRIPTION="library for accessing smart card terminals"
HOMEPAGE="http://www.opensc-project.org/openct/"

if [[ "${PV}" = "9999" ]]; then
	inherit subversion autotools
	ESVN_REPO_URI="http://www.opensc-project.org/svn/${PN}/trunk"
	KEYWORDS=""
else
	SRC_URI="http://www.opensc-project.org/files/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="usb doc"

RDEPEND=">=sys-fs/udev-096
	usb? ( >=dev-libs/libusb-0.1.7 )
	doc? ( dev-util/doxygen )"

[[ "${PV}" = "9999" ]] && DEPEND="${DEPEND}
	dev-libs/libxslt"

pkg_setup() {
	enewgroup openct
	enewuser openctd
}

src_unpack() {
	if [ "${PV}" = "9999" ]; then
		subversion_src_unpack
		cd "${S}"
		eautoreconf
	else
		unpack "${A}"
		cd "${S}"
	fi
}

src_compile() {
	econf \
		--docdir="/usr/share/doc/${PF}" \
		--htmldir="/usr/share/doc/${PF}/html" \
		--localstatedir=/var \
		--with-udev="/$(get_libdir)/udev" \
		--enable-non-privileged \
		--with-daemon-user=openctd \
		--with-daemon-groups=usb \
		$(use_enable usb) \
		$(use_enable doc) \
		$(use_enable doc api-doc) \
		|| die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	prepalldocs

	insinto /etc/udev/rules.d/
	newins etc/openct.udev 70-openct.rules || die

	diropts -m0750 -gopenct -oopenctd
	keepdir /var/run/openct

	newinitd "${FILESDIR}"/openct.rc openct
}

pkg_postinst() {
	elog
	elog "You need to edit /etc/openct.conf to enable serial readers."
	elog
	elog "You should add \"openct\" to your default runlevel. To do so"
	elog "type \"rc-update add openct default\"."
	elog
	elog "You need to be a member of the (newly created) group openct to"
	elog "access smart card readers connected to this system. Set users'"
	elog "groups with usermod -G.  root always has access."
	elog
}
