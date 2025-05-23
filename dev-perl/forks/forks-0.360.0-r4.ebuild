# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RYBSKEJ
DIST_VERSION=0.36
inherit perl-module

DESCRIPTION="Emulate threads with fork"

SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="
	dev-perl/Acme-Damn
	dev-perl/Devel-Symdump
	virtual/perl-File-Spec
	>=virtual/perl-IO-1.180.0
	>=dev-perl/List-MoreUtils-0.150.0
	>=virtual/perl-Scalar-List-Utils-1.110.0
	virtual/perl-Storable
	>=dev-perl/Sys-SigAction-0.110.0
	virtual/perl-Time-HiRes
	virtual/perl-if
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

PERL_RM_FILES=(
	t/forks99.t
)
