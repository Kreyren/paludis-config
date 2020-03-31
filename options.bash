# NOTICE(Krey): This is configured to apply use flags based on presence in world file
# NOTICE(Krey): Priority is declared depending on the order -> Configuration on EOF overwrites the configuration on BOF

# FIXME(Krey)-QA: '|| true' is a hotfix

worldFile="/etc/paludis/world"

# NOTICE(Krey): /etc/paludis/bashrc is not sourced for this =_="
# This function expects PCRE RegEx expression from the world file
checkpkg() { grep -qP "$1" "$worldFile" ;}

# Flameshot
checkpkg "^x11-apps\/flameshot\$" && printf '%s\n' \
	"x11-libs/libxkbcommon:0::x11[=0.9.1] X" \
	"x11-libs/qtbase:5::x11[=5.14.1] sql sqlite gui" \
	"x11-dri/mesa:0::x11 X" \
	"x11-libs/qttools:5::x11[>=5.12.7] gui" || true

# tint2
checkpkg "^x11-misc\/tint2\$" && printf '%s\n' \
	"media-libs/imlib2[=1.5.1] X" || true

# GRUB
#checkpkg "^sys-boot\/grub:0::arbor\$" && printf '%s\n' \
#	"sys-boot/grub[=2.04] device-mapper" || true

# GIMP
checkpkg "^media-gfx\/gimp\$" && printf '%s\n' \
	"media-gfx/gimp aalib alsa heif hdr jpeg2000 mng webp wmf" || true

# Firefox
## FIXME: Why do we need wayland
checkpkg "^net-www\/firefox\$" && printf '%s\n' \
	"x11-libs/gtk+:3::x11[=3.24.14] wayland" \
	"x11-libs/cairo:0::x11[=1.16.0] X" \
	"x11-dri/mesa:0::x11[=19.3.5] X wayland valgrind zstd" \
	"dev-lang/python:3.7::arbor[=3.7.7] sqlite" \
	"dev-lang/python:2.7::arbor[=2.7.17] sqlite" \
	"net-www/firefox:0::desktop[=74.0] alsa eme lto pgo" || true

# Paludis
## FIXME: test failure - 20 - gtest_throw_on_failure_ex_test (Child aborted)
## FIXME: paludis fails with many tests
# sydbox seccomp - Used by paludis
checkpkg "^sys-apps\/paludis\$" && printf '%s\n' \
	"dev-cpp/gtest:0::arbor[=1.8.1] BUILD_OPTIONS: -recommended_tests" \
	"sys-apps/sydbox seccomp" \
	"sys-apps/paludis:0::arbor[=scm] pbin BUILD_OPTIONS: -recommended_tests" || true

# GIT
checkpkg "^dev-scm\/git\$" && printf '%s\n' \
	"dev-scm/git curl" || true

# MESA
## Stub for expected flags
checkpkg "^x11-dri\/mesa\$" && printf '%s\n' \
	"x11-dri/mesa:0::x11 -X d3d9 llvm valgrind VIDEO_DRIVERS: gallium-swrast" \
	"dev-libs/libglvnd:0::x11[=1.3.0-r1] X" \
	"dev-libs/libglvnd:0::x11[=1.3.1] X" \
	"dev-libs/libepoxy:0::x11[>=1.5.4-r2] X" \
	"dev-python/pytest:0::python[=3.10.1-r1] BUILD_OPTIONS: -recommended_tests" \
	"dev-lang/python:3.6::arbor[=3.6.10] sqlite" || true

# VIM
checkpkg "^app-editors\/vim\$" && printf '%s\n' \
	"app-editors/vim:0::arbor x-clipboard gpm cscope" \
	"*/* vim-syntax" || true

# XORG
## FIXME: This GPU is apparently radeon-legacy NOT radeon
checkpkg "^x11-server\/xorg-server\$" && printf '%s\n' \
	"dev-libs/libepoxy:0::x11[>=1.4.4] X" \
	"x11-dri/mesa:0::x11[>=10.2.0] X valgrind" \
	"dev-libs/libglvnd:0::x11[=1.3.0-r1] X" || true

# WINE
checkpkg "^app-emulation\/wine\$" && printf '%s\n' \
	"dev-libs/libxml2:2.0::arbor[=2.9.10-r1] python" \
	"app-emulation/wine:0::virtualization mono opengl sdl staging" || true
