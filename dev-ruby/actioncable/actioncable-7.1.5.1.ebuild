# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_EXTRAINSTALL="app"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Integrated WebSockets for Rails"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"

RUBY_S="rails-${PV}/${PN}"

# Tests require many new dependencies, skipping for now
RESTRICT="test"

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}:*
	~dev-ruby/activesupport-${PV}:*
	dev-ruby/nio4r:2
	>=dev-ruby/websocket-driver-0.6.1:*
	>=dev-ruby/zeitwerk-2.6:2
"

ruby_add_bdepend "
	test? (
		>=dev-ruby/railties-4.2.0
		dev-ruby/test-unit:2
		dev-ruby/mocha
	)"
