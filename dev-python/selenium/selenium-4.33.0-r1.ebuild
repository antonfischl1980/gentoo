# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( python3_{11..14} pypy3_11 )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" )

inherit distutils-r1 pypi

# base releases are usually ${P}, followups ${P}-python
TEST_TAG=${P}
[[ ${PV} != *.0 ]] && TEST_TAG+=-python
TEST_P=selenium-${TEST_TAG}

DESCRIPTION="Python language binding for Selenium Remote Control"
HOMEPAGE="
	https://www.seleniumhq.org/
	https://github.com/SeleniumHQ/selenium/tree/trunk/py/
	https://pypi.org/project/selenium/
"
SRC_URI+="
	test? (
		https://github.com/SeleniumHQ/selenium/archive/${TEST_TAG}.tar.gz
			-> ${TEST_P}.gh.tar.gz
	)
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ~ppc64 ~riscv ~s390 sparc ~x86"
IUSE="test test-rust"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/certifi-2025.4.26[${PYTHON_USEDEP}]
	>=dev-python/trio-0.30[${PYTHON_USEDEP}]
	>=dev-python/trio-websocket-0.12.2[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.13.2[${PYTHON_USEDEP}]
	>=dev-python/urllib3-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/websocket-client-1.8.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		$(python_gen_cond_dep '
			dev-python/filetype[${PYTHON_USEDEP}]
			dev-python/pytest-mock[${PYTHON_USEDEP}]
			test-rust? (
				dev-python/pytest[${PYTHON_USEDEP}]
				dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
				dev-python/pytest-xdist[${PYTHON_USEDEP}]
				dev-util/selenium-manager
				net-misc/geckodriver
				|| (
					www-client/firefox
					www-client/firefox-bin
				)
			)
		' "${PYTHON_TESTED[@]}")
	)
"

src_prepare() {
	distutils-r1_src_prepare

	# do not build selenium-manager implicitly
	sed -e 's:\[tool\.setuptools-rust:[tool.ignore-me:' \
		-i pyproject.toml || die
	# unpin deps
	sed -i -e 's:~=:>=:g' pyproject.toml || die

	if use test; then
		cd "${WORKDIR}/${TEST_P}" || die
		eapply "${FILESDIR}/${P}-pytest-ignore.patch"
	fi
}

python_test() {
	# NB: xdist is causing random pytest crashes with high job numbers

	if ! has "${EPYTHON/./_}" "${PYTHON_TESTED[@]}"; then
		einfo "Skipping tests on ${EPYTHON}"
		return
	fi

	local EPYTEST_IGNORE=()
	local EPYTEST_DESELECT=(
		# expects vanilla certifi
		test/unit/selenium/webdriver/remote/remote_connection_tests.py::test_get_connection_manager_for_certs_and_timeout
	)
	local pytest_args=(
		# https://github.com/SeleniumHQ/selenium/blob/selenium-4.8.2-python/py/test/runner/run_pytest.py#L20-L24
		# seriously?
		-o "python_files=*_tests.py test_*.py"
		-p pytest_mock
	)
	if use test-rust; then
		local -x PATH=${T}/bin:${PATH}
		local -x SE_MANAGER_PATH="$(type -P selenium-manager)"

		pytest_args+=(
			-p rerunfailures --reruns=5

			--driver=firefox
			--browser-binary="$(type -P firefox || type -P firefox-bin)"
			--driver-binary="$(type -P geckodriver)"
			--headless
		)

		local EPYTEST_IGNORE+=(
			# requires some "python.runfiles", also bidi tests generally fail
			test/selenium/webdriver/common/bidi_webextension_tests.py
		)
		EPYTEST_DESELECT+=(
			# expects prebuilt executables for various systems
			test/selenium/webdriver/common/selenium_manager_tests.py::test_uses_windows
			test/selenium/webdriver/common/selenium_manager_tests.py::test_uses_linux
			test/selenium/webdriver/common/selenium_manager_tests.py::test_uses_mac
			test/selenium/webdriver/common/selenium_manager_tests.py::test_errors_if_invalid_os

			# TODO: these don't respect --*-binary and try to fetch versions
			test/selenium/webdriver/firefox
			test/selenium/webdriver/marionette/mn_context_tests.py::test_context_sets_correct_context_and_returns
			test/selenium/webdriver/marionette/mn_context_tests.py::test_context_sets_correct_context_and_returns
			test/selenium/webdriver/marionette/mn_options_tests.py::TestIntegration::test_we_can_pass_options
			test/selenium/webdriver/marionette/mn_set_context_tests.py::test_we_can_switch_context_to_chrome

			# TODO
			'test/selenium/webdriver/common/devtools_tests.py::test_check_console_messages[firefox]'

			# TODO
			test/selenium/webdriver/common/bidi_browser_tests.py
			test/selenium/webdriver/common/bidi_browsing_context_tests.py
			test/selenium/webdriver/common/bidi_network_tests.py
			test/selenium/webdriver/common/bidi_script_tests.py
			test/selenium/webdriver/common/bidi_session_tests.py
			test/selenium/webdriver/common/bidi_storage_tests.py
			test/selenium/webdriver/common/bidi_tests.py
			test/selenium/webdriver/marionette/mn_options_tests.py::TestUnit::test_binary
			test/selenium/webdriver/marionette/mn_options_tests.py::TestUnit::test_ctor
			test/selenium/webdriver/marionette/mn_options_tests.py::TestUnit::test_prefs
			test/selenium/webdriver/marionette/mn_options_tests.py::TestUnit::test_to_capabilities
		)
	else
		EPYTEST_IGNORE+=(
			test/selenium
		)
	fi

	cd "${WORKDIR}/${TEST_P}/py" || die
	rm -rf selenium || die
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest "${pytest_args[@]}"
}
