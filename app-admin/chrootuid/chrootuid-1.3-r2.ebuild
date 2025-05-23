# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit toolchain-funcs

MY_P="${P/-/}"

DESCRIPTION="Run a network service at low privilege level and restricted file system access"
HOMEPAGE="http://ftp.porcupine.org/pub/security/index.html"
SRC_URI="http://ftp.porcupine.org/pub/security/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ppc x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

DOCS=( README ${PN}_license )

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	einstalldocs
}
