# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="A tool for building, changing, and combining infrastructure safely"
HOMEPAGE="https://www.terraform.io/"
SRC_URI="https://github.com/hashicorp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="BUSL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

BDEPEND="dev-go/gox"

RESTRICT="test"

DOCS=( {README,CHANGELOG}.md )

src_compile() {
	export CGO_ENABLED=0
	LD_FLAGS="-X 'github.com/hashicorp/terraform/version.dev=no'"
	gox \
		-os=$(go env GOOS) \
		-arch=$(go env GOARCH) \
		-ldflags "${LD_FLAGS}" \
		-output bin/terraform \
		-verbose \
		. || die
}

src_install() {
	dobin bin/*
	einstalldocs
}

pkg_postinst() {
	elog "If you would like to install shell completions please run:"
	elog "    terraform -install-autocomplete"
}
