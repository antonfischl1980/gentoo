# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_MULTILIB=yes
inherit xorg-3

DESCRIPTION="X C-language Bindings sample implementations"
HOMEPAGE="https://xcb.freedesktop.org/"
SRC_URI="https://github.com/Airblader/${PN}/releases/download/v${PV}/${P}.tar.bz2"

KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv x86"

RDEPEND=">=x11-libs/libxcb-1.9.1:=[${MULTILIB_USEDEP}]
	x11-libs/xcb-util[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	elibc_musl? ( sys-libs/queue-standalone )
	x11-base/xorg-proto
	x11-libs/libX11[${MULTILIB_USEDEP}]" # Only for tests, but configure.ac requires it
