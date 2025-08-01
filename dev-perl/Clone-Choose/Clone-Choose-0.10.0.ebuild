# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=HERMES
DIST_VERSION=0.010
inherit perl-module

DESCRIPTION="Choose appropriate clone utility"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~mips ppc ~ppc64 ~riscv ~s390 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Module-Runtime
	virtual/perl-Storable
"
BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.900.0
		dev-perl/Test-Without-Module
		>=dev-perl/Clone-0.100.0
		dev-perl/Clone-PP
	)
"
