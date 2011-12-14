# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/opensc/opensc-0.12.0.ebuild,v 1.1 2011/03/14 00:33:33 kingtaco Exp $

EAPI="2"

inherit autotools

DESCRIPTION="SmartCard library and applications"
HOMEPAGE="http://www.opensc-project.org/opensc/"

if [[ "${PV}" = "9999" ]]; then
	inherit subversion
	ESVN_REPO_URI="http://www.opensc-project.org/svn/${PN}/trunk"
	KEYWORDS=""
else
	SRC_URI="http://www.opensc-project.org/files/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc +pcsc-lite openct +readline +ssl +zlib"

RDEPEND="sys-devel/libtool
	zlib? ( sys-libs/zlib )
	readline? ( sys-libs/readline )
	ssl? ( dev-libs/openssl )
	openct? ( >=dev-libs/openct-0.5.0 )
	pcsc-lite? ( >=sys-apps/pcsc-lite-1.3.0 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? (
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)"

pkg_setup() {
	! use openct && ! use pcsc-lite && die "Please select openct or pcsc-lite"
	use openct && use pcsc-lite && die "Please select openct or pcsc-lite"
}

src_unpack() {
	if [ "${PV}" = "9999" ]; then
		subversion_src_unpack
		cd "${S}"
	else
		unpack "${A}"
		cd "${S}"
	fi
}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--docdir="/usr/share/doc/${PF}" \
		--htmldir="/usr/share/doc/${PF}/html" \
		$(use_enable doc) \
		$(use_enable openct) \
		$(use_enable pcsc-lite pcsc) \
		$(use_enable readline) \
		$(use_enable ssl openssl) \
		$(use_enable zlib) \
		|| die
}

src_install() {
	emake install DESTDIR="${D}" || die
}
