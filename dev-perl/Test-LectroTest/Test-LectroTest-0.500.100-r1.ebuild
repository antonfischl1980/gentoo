# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TMOERTEL
DIST_VERSION=0.5001
inherit perl-module

DESCRIPTION="Easy, automatic, specification-based tests"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Exporter
	virtual/perl-Test-Simple
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Temp
	)
"

PERL_RM_FILES=(
	"t/pod-coverage.t"
	"t/pod.t"
	"t/release-pod-coverage.t"
	"t/release-pod-syntax.t"
)
