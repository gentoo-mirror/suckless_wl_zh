# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit savedconfig git-r3 toolchain-funcs

EGIT_REPO_URI="https://gitee.com/guyuming76/dwl"
EGIT_BRANCH="0.7cn"

DESCRIPTION="DWL with fcitx5 support"
HOMEPAGE="https://gitee.com/guyuming76/dwl/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="+seatd X waybar +foot +wmenu +fcitx +grim +imv +mpv +rfm wf-recorder +wl-clipboard"

WLROOTS_DEP="
	>=gui-libs/wlroots-0.18:=[libinput,session,X?]
"

CDEPEND="
	${WLROOTS_DEP}
	dev-libs/libinput:=
	dev-libs/wayland
	x11-libs/libxkbcommon
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-wm
	)
"


RDEPEND="
	${CDEPEND}
	X? (
		x11-base/xwayland
	)
	wmenu? (
		gui-apps/wmenu
	)
	foot? (
		gui-apps/foot
	)
	waybar? (
		=gui-apps/waybar-0.9.22
		sys-fs/inotify-tools
		gui-apps/wtype
	)
	grim? (
		gui-apps/grim
		gui-apps/slurp
	)
	imv? (
		media-gfx/imv[wayland,jpeg,png,gif,svg,tiff]
	)
	mpv? (
		media-video/mpv
	)
	wf-recorder? (
		gui-apps/wf-recorder
	)
	wl-clipboard? (
		gui-apps/wl-clipboard
	)
	fcitx? (
		app-i18n/fcitx:5[wayland]
		app-i18n/fcitx-chinese-addons:5
		app-i18n/fcitx-gtk:5[wayland]
		media-fonts/wqy-zenhei
	)
	rfm? (
		gui-apps/rfm[wayland]
	)
	seatd? (
		sys-auth/seatd[builtin,server,-elogind,-systemd]
	)
"
# gui-apps/wtype::guru
# fcitx:5::gentoo-zh

# uses <linux/input-event-codes.h>
DEPEND="
	${CDEPEND}
	sys-kernel/linux-headers
"

BDEPEND="
	>=dev-libs/wayland-protocols-1.32
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_prepare() {
	restore_config config.h

	default
}

src_configure() {
	# replace /local with nothing (remove /local) in config.mk
	sed -i "s:/local::g" config.mk || die

	sed -i "s:pkg-config:$(tc-getPKG_CONFIG):g" config.mk || die

	if ! use X; then
		sed -i "s:-DXWAYLAND::g" config.mk || die
		sed -i "s:xcb xcb-icccm::g" config.mk || die
	fi
}

src_install() {
	default

	insinto /usr/bin
# -rwxr_xr_x
	insopts -m0755
		doins xdg_run_user
		doins dwl.sh
		doins screenshot.sh

	if use waybar; then
		doins waybar/waybar-dwl.sh
		doins waybar/dwlstart.sh
		doins waybar/sleep.sh

		insinto /etc/xdg/waybar
		insopts -m0644
		doins waybar/style_dwl.css
		doins waybar/config_dwl

	else
		doins dwlstart.sh
	fi

	if use seatd; then
		rc-update add seatd default
	fi

	save_config config.h

}
