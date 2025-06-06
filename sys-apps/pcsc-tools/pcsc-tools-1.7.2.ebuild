# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs xdg-utils

DESCRIPTION="PC/SC Architecture smartcard tools"
HOMEPAGE="https://pcsc-tools.apdu.fr/ https://github.com/LudovicRousseau/pcsc-tools"
SRC_URI="https://pcsc-tools.apdu.fr/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 x86"
IUSE="gui network-cron nls"

DEPEND=">=sys-apps/pcsc-lite-1.4.14"
RDEPEND="
	${DEPEND}
	dev-perl/pcsc-perl
	gui? ( dev-perl/Gtk3 )
"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_configure() {
	econf $(use_enable nls gettext)
}

src_compile() {
	# explicitly only build the pcsc_scan application, or the man
	# pages will be gzipped first, and then unpacked.
	emake pcsc_scan CC="$(tc-getCC)"
}

src_install() {
	einstalldocs

	# install manually, makes it much easier since the Makefile
	# requires fiddling with
	dobin ATR_analysis scriptor pcsc_scan
	doman pcsc_scan.1 scriptor.1p ATR_analysis.1p

	if use gui; then
		domenu gscriptor.desktop
		dobin gscriptor
		doman gscriptor.1p
	fi

	if use network-cron ; then
		exeinto /etc/cron.monthly
		newexe "${FILESDIR}"/smartcard.cron update-smartcard_list
	fi

	insinto /usr/share/pcsc
	doins smartcard_list.txt
}

pkg_postinst() {
	use gui && xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
