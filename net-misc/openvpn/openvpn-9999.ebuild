# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/openvpn/openvpn-9999.ebuild,v 1.4 2012/06/01 04:02:16 zmedico Exp $

EAPI="4"

inherit eutils multilib autotools git-2

DESCRIPTION="OpenVPN is a robust and highly flexible tunneling application compatible with many OSes."
EGIT_REPO_URI="https://github.com/alonbl/${PN}.git"
EGIT_BRANCH="plugin"
HOMEPAGE="http://openvpn.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE_PLUGIN="openvpn_plugin_auth-pam openvpn_plugin_down-root"
IUSE="examples iproute2 +plugins passwordsave selinux +ssl +lzo static pkcs11 userland_BSD ${IUSE_PLUGIN}"

REQUIRED_USE="static? ( !plugins !pkcs11 )
	!plugins? ( !openvpn_plugin_auth-pam !openvpn_plugin_down-root )"

DEPEND="
	kernel_linux? (
		iproute2? ( sys-apps/iproute2[-minimal] ) !iproute2? ( sys-apps/net-tools )
	)
	openvpn_plugin_auth-pam? ( virtual/pam )
	selinux? ( sec-policy/selinux-openvpn )
	ssl? ( >=dev-libs/openssl-0.9.7 )
	lzo? ( >=dev-libs/lzo-1.07 )
	pkcs11? ( >=dev-libs/pkcs11-helper-1.05 )"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	use static && LDFLAGS="${LDFLAGS} -Xcompiler -static"
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable passwordsave password-save) \
		$(use_enable ssl) \
		$(use_enable ssl crypto) \
		$(use_enable lzo) \
		$(use_enable pkcs11) \
		$(use_enable plugins) \
		$(use_enable iproute2) \
		$(use_enable openvpn_plugin_auth-pam plugin-auth-pam) \
		$(use_enable openvpn_plugin_down-root plugin-down-root)
}

src_install() {
	default
	find "${ED}/usr" -name '*.la' -delete

	# install documentation
	dodoc AUTHORS ChangeLog PORTS README README.IPv6

	# Install some helper scripts
	keepdir /etc/openvpn
	exeinto /etc/openvpn
	doexe "${FILESDIR}/up.sh"
	doexe "${FILESDIR}/down.sh"

	# Install the init script and config file
	newinitd "${FILESDIR}/${PN}-2.1.init" openvpn
	newconfd "${FILESDIR}/${PN}-2.1.conf" openvpn

	# install examples, controlled by the respective useflag
	if use examples ; then
		# dodoc does not supportly support directory traversal, #15193
		insinto /usr/share/doc/${PF}/examples
		doins -r sample contrib
	fi
}

pkg_postinst() {
	# Add openvpn user so openvpn servers can drop privs
	# Clients should run as root so they can change ip addresses,
	# dns information and other such things.
	enewgroup openvpn
	enewuser openvpn "" "" "" openvpn

	if [ path_exists -o "${ROOT}/etc/openvpn/*/local.conf" ] ; then
		ewarn "WARNING: The openvpn init script has changed"
		ewarn ""
	fi

	elog "The openvpn init script expects to find the configuration file"
	elog "openvpn.conf in /etc/openvpn along with any extra files it may need."
	elog ""
	elog "To create more VPNs, simply create a new .conf file for it and"
	elog "then create a symlink to the openvpn init script from a link called"
	elog "openvpn.newconfname - like so"
	elog "   cd /etc/openvpn"
	elog "   ${EDITOR##*/} foo.conf"
	elog "   cd /etc/init.d"
	elog "   ln -s openvpn openvpn.foo"
	elog ""
	elog "You can then treat openvpn.foo as any other service, so you can"
	elog "stop one vpn and start another if you need to."

	if grep -Eq "^[ \t]*(up|down)[ \t].*" "${ROOT}/etc/openvpn"/*.conf 2>/dev/null ; then
		ewarn ""
		ewarn "WARNING: If you use the remote keyword then you are deemed to be"
		ewarn "a client by our init script and as such we force up,down scripts."
		ewarn "These scripts call /etc/openvpn/\$SVCNAME-{up,down}.sh where you"
		ewarn "can move your scripts to."
	fi

	ewarn ""
	ewarn "You are using a live ebuild building from the sources of openvpn"
	ewarn "repository from http://openvpn.git.sourceforge.net. For reporting"
	ewarn "bugs please contact: openvpn-devel@lists.sourceforge.net."
}
