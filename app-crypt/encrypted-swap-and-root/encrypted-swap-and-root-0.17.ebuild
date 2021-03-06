# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Software Suspend and Loop-AES Disk Encryption"
HOMEPAGE="http://wiki.tuxonice.net/EncryptedSwapAndRoot"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="smartcard gnupg aescrypt"

DEPEND=""
RDEPEND="sys-fs/loop-aes[keyscrub]
	app-crypt/loop-aes-losetup[static]
	app-crypt/aespipe[static]
	app-misc/genkernel-utils
	sys-apps/boot-digest
	gnupg? ( app-crypt/gnupg )
	aescrypt? ( app-crypt/aescrypt[static] )
	smartcard? ( >=app-crypt/pkcs11-data-0.3 )"

src_install() {
	dodoc ${FILESDIR}/Linux_Disk_Encryption_Using_LoopAES_And_SmartCards.wiki
}

