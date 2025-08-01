# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="USB3380 abstraction layer for libusb"
HOMEPAGE="https://github.com/xtrx-sdr/libusb3380"
if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xtrx-sdr/libusb3380.git"
else
	COMMIT="c83d1e93eb3a5b8b6a9db41c2613b206f344f825"
	SRC_URI="https://github.com/xtrx-sdr/libusb3380/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"

src_prepare() {
	# fix build with cmake 4
	sed -i -e "s/VERSION 2.8/VERSION 3.10/" CMakeLists.txt || die
	cmake_src_prepare
}
