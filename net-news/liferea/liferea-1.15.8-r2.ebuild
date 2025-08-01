# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit autotools gnome2-utils optfeature python-single-r1 xdg

DESCRIPTION="News Aggregator for RDF/RSS/CDF/Atom/Echo feeds"
HOMEPAGE="https://lzone.de/liferea/"
SRC_URI="https://github.com/lwindolf/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-db/sqlite:3
	dev-libs/fribidi
	dev-libs/glib:2
	dev-libs/gobject-introspection
	dev-libs/json-glib
	dev-libs/libpeas:0[gtk,python,${PYTHON_SINGLE_USEDEP}]
	dev-libs/libxml2:2=
	dev-libs/libxslt
	gnome-base/gsettings-desktop-schemas
	net-libs/libsoup:3.0
	net-libs/webkit-gtk:4.1=
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/pango"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/intltool
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_compile() {
	# Workaround crash in libwebkit2gtk-4.0.so
	# https://bugs.gentoo.org/704594
	WEBKIT_DISABLE_COMPOSITING_MODE=1 \
		default
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	optfeature "Libsecret Support plugin" app-crypt/libsecret[introspection]
	optfeature "Tray Icon (AppIndicator and GNOME Classic) plugin" \
		"dev-libs/libayatana-appindicator dev-python/pycairo x11-libs/gdk-pixbuf[introspection]"
	optfeature "Media Player plugin" media-libs/gstreamer[introspection]
	optfeature "monitoring network status" net-misc/networkmanager
	optfeature "Popup Notifications plugin" x11-libs/libnotify[introspection]
}
