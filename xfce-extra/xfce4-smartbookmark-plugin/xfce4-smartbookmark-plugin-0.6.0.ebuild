# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Smart bookmark plug-in for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-smartbookmark-plugin
	https://gitlab.xfce.org/panel-plugins/xfce4-smartbookmark-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.xz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-libs/glib-2.50.0
	>=x11-libs/gtk+-3.22.0:3
	>=xfce-base/libxfce4ui-4.16.0:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfce4-panel-4.16.0:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	# substitute default bugtracker
	sed -i -e '/bugs/s:bugs\.debian:bugs.gentoo:' src/smartbookmark.c || die
	default
}
