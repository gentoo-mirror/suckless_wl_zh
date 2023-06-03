# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic savedconfig toolchain-funcs

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://gitee.com/guyuming76/rfm"
	inherit git-r3
fi

DESCRIPTION="suckless style file manager"
HOMEPAGE="https://gitee.com/guyuming76/rfm/"

LICENSE="MIT"
SLOT="0"
IUSE="+alacritty "

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	x11-libs/gtk+:3
"

src_prepare() {
	restore_config config.h

	default
}


src_install() {
	default

	save_config config.h

	insinto /usr/share/applications
	doins rfm.desktop

}

pkg_postinst() {
	desktop_database_update
}


pkg_postrm() {
	desktop_database_update
}
