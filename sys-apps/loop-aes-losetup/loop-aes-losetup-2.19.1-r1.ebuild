# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/util-linux/util-linux-2.19.1-r1.ebuild,v 1.9 2011/11/12 22:16:56 polynomial-c Exp $

EAPI="3"

EGIT_REPO_URI="git://git.kernel.org/pub/scm/utils/util-linux/util-linux.git"
inherit eutils toolchain-funcs flag-o-matic autotools

MY_PV=${PV/_/-}
MY_P=util-linux-${MY_PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Various useful Linux utilities"
HOMEPAGE="http://www.kernel.org/pub/linux/utils/util-linux/"
SRC_URI="mirror://kernel/linux/utils/util-linux/v${PV:0:4}/${MY_P}.tar.bz2
	http://loop-aes.sourceforge.net/updates/util-linux-2.19.1-20110510.diff.bz2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-linux"

LICENSE="GPL-2"
SLOT="0"
IUSE="nls selinux uclibc static"

RDEPEND="selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/os-headers"

src_prepare() {
	epatch "${WORKDIR}"/util-linux-*.diff
	use uclibc && sed -i -e s/versionsort/alphasort/g -e s/strverscmp.h/dirent.h/g mount/lomount.c
	eautoreconf
}

lfs_fallocate_test() {
	# Make sure we can use fallocate with LFS #300307
	cat <<-EOF > "${T}"/fallocate.c
	#define _GNU_SOURCE
	#include <fcntl.h>
	main() { return fallocate(0, 0, 0, 0); }
	EOF
	append-lfs-flags
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} "${T}"/fallocate.c -o /dev/null >/dev/null 2>&1 \
		|| export ac_cv_func_fallocate=no
	rm -f "${T}"/fallocate.c
}

usex() { use $1 && echo ${2:-yes} || echo ${3:-no} ; }
src_configure() {
	lfs_fallocate_test
	econf \
		$(use_enable nls) \
		--without-ncurses \
		--disable-agetty \
		--disable-chsh-only-listed \
		--disable-cramfs \
		--disable-fallocate \
		--disable-fsck \
		--disable-init \
		--disable-kill \
		--disable-last \
		--enable-libblkid \
		--disable-libmount \
		--disable-libuuid \
		--disable-login-utils \
		--disable-mesg \
		--disable-pg-bell \
		--disable-pivot_root \
		--disable-rename \
		--disable-require-password \
		--disable-reset \
		--disable-schedutils \
		--disable-switch_root \
		--disable-unshare \
		--disable-use-tty-group \
		--disable-uuidd \
		--without-pam \
		$(use_with selinux) \
		$(tc-has-tls || echo --disable-tls) \
		--enable-mount \
		$(use static && echo --enable-static-programs=losetup)
}

src_install() {
	emake install DESTDIR="${T}/root" || die "install failed"
	newsbin "${T}/root/sbin/losetup" loop-aes-losetup
	use static && newsbin "${T}/root/bin/losetup.static" loop-aes-losetup.static
}
