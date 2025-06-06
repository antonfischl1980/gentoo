# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
ECM_HANDBOOK="optional"
ECM_HANDBOOK_DIR="docs"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.9
inherit ecm frameworks.kde.org xdg-utils

DESCRIPTION="Framework providing transparent file and data management"

LICENSE="LGPL-2+"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv ~x86"
IUSE="acl kerberos +kwallet X"

# tests hang
RESTRICT="test"

COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5[ssl]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	=kde-frameworks/kauth-${PVCUT}*:5
	=kde-frameworks/karchive-${PVCUT}*:5
	=kde-frameworks/kbookmarks-${PVCUT}*:5
	=kde-frameworks/kcodecs-${PVCUT}*:5
	=kde-frameworks/kcompletion-${PVCUT}*:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kconfigwidgets-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kcrash-${PVCUT}*:5
	=kde-frameworks/kdbusaddons-${PVCUT}*:5
	=kde-frameworks/kguiaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/kiconthemes-${PVCUT}*:5
	=kde-frameworks/kitemviews-${PVCUT}*:5
	=kde-frameworks/kjobwidgets-${PVCUT}*:5
	=kde-frameworks/knotifications-${PVCUT}*:5
	=kde-frameworks/kservice-${PVCUT}*:5
	=kde-frameworks/ktextwidgets-${PVCUT}*:5
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:5
	=kde-frameworks/kwindowsystem-${PVCUT}*:5[X?]
	=kde-frameworks/kxmlgui-${PVCUT}*:5
	=kde-frameworks/solid-${PVCUT}*:5
	sys-power/switcheroo-control
	acl? (
		sys-apps/attr
		virtual/acl
	)
	handbook? (
		dev-libs/libxml2
		dev-libs/libxslt
		=kde-frameworks/kdoctools-${PVCUT}*:5
	)
	kerberos? ( virtual/krb5 )
	kwallet? ( =kde-frameworks/kwallet-${PVCUT}*:5 )
	X? ( >=dev-qt/qtx11extras-${QTMIN}:5 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtconcurrent-${QTMIN}:5
	test? ( sys-libs/zlib )
"
RDEPEND="${COMMON_DEPEND}
	|| (
		kde-apps/kio-extras:6
		kde-frameworks/kio-trash-desktop-file:5
	)
"
PDEPEND=">=kde-frameworks/kded-${PVCUT}:5"

PATCHES=( "${FILESDIR}/${P}-use-solid-for-home-mountpoint.patch" )

src_configure() {
	local mycmakeargs=(
		-DKF6_COMPAT_BUILD=ON
		-DKIO_NO_PUBLIC_QTCONCURRENT=ON
		$(cmake_use_find_package acl ACL)
		$(cmake_use_find_package kerberos GSSAPI)
		$(cmake_use_find_package kwallet KF5Wallet)
		-DWITH_X11=$(usex X)
	)

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst
	xdg_desktop_database_update
}

pkg_postrm() {
	ecm_pkg_postrm
	xdg_desktop_database_update
}
