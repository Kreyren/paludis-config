# NOTICE(Krey): This is configured to apply use flags based on presence in world file

# FIXME: '|| true' is a hotfix

# NOTICE(Krey): /etc/paludis/bashrc is not sourced for this =.="
checkpkg() {
	grep -qP "^$1" /etc/paludis/world
}


# Flameshot
checkpkg "x11-apps/flameshot" && printf '%s\n' \
	"x11-libs/libxkbcommon:0::x11[=0.9.1] X" \
	"x11-libs/qtbase:5::x11[=5.14.1] sqlite sql" || true

# GIT
checkpkg "dev-scm/git" && printf '%s\n' \
	"dev-scm/git curl" || true

# VIM
checkpkg "app-editors/vim" && printf '%s\n' \
	"app-editors/vim:0::arbor[=8.1.1467] gdm x-clipboard bash-completition" || true

# tint2
checkpkg "x11-misc/tint2" && printf '%s\n' \
	"media-libs/imlib2[=1.5.1] X" || true

# GRUB
checkpkg "sys-boot/grub" && printf '%s\n' \
	"sys-boot/grub[=2.04] device-mapper" || true 

# GIMP
checkpkg "media-gfx/gimp" && printf '%s\n' \
	"media-gfx/gimp aalib alsa heif hdr jpeg2000 mng webp wmf" || true
