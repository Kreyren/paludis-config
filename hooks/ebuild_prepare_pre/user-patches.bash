## Copyright 2019 Jacob Hrbek <kreyren@rixotstudio.cz>
## Distributed under the terms of the GNU General Public License v3
# Based in part upon 'https://github.com/Keruspe/paludis-config/blob/exherbo/hooks/ebuild_prepare_pre/patches.bash' from Exherbo, which is:
# 		Unlicenced (apparently?)

# This file is used for sourcing from /etc/paludis/hook/ebuild_prepare_pre/user-patches.sh

# Export edebug
# TODO: Not exported in this stage
require exdebug

if [ "$DEBUG_INIT" != kreyren ]; then
	ewarn "Exlib 'exdebug' from kreyren is not sourced, debugging messages are set on default"
	exdebug() { [ -n "$DEBUG" ] && { printf '%s\n' "DEBUG(exported): $@" ;} || true ;}
elif [ "$DEBUG_INIT" = kreyren ]; then
	# Output in build log since this might be a factor in debuging for upstream
	einfo "User-patches hook made by kreyren has been sourced"
fi

# Helper: POSIX compatibility for wildcard matching since [ -e ".../*.patch" ] doesn't work and using case statement is mindfuck
exists() { [ -s "$1" ] ;}

# Purpose: Apply user-patches from patch directory
# Maintainer: Jacob Hrbek <kreyren@rixotstudio.cz>
# Usage: grabs patches from defined patchdir variable path and applies them
# References:
# - gitlab issue (https://gitlab.exherbo.org/kreyren/exheredrey/issues/84)
# - inspiration (https://github.com/Keruspe/paludis-config/blob/exherbo/hooks/ebuild_prepare_pre/patches.bash)
## Sanitycheck for /etc/paludis
if [ -s "/etc/paludis/options.conf" ]; then
	exdebug "File '/etc/paludis/options' exists and is not blank, assuming valid paludis directory"
elif [ ! -e "/etc/paludis/options.conf" ]; then
	die "File '/etc/paludis/option.conf' is not valid paludis directory since options.conf with size greater then zero is not present."
fi

## Directory from which we are going to read patches
if [ -z "$PALUDIS_PATCHDIR" ]; then
	einfo "Variable 'PALUDIS_PATCHDIR' with value '$PALUDIS_PATCHDIR' is blank, exporting default path as '/etc/paludis/patches'"
	export PALUDIS_PATCHDIR="/etc/paludis/patches"
elif [ -n "$PALUDIS_PATCHDIR" ]; then
	einfo "Variable 'PALUDIS_PATCHDIR' with value '$PALUDIS_PATCHDIR' is not blank, applying user-patches is enabled"
fi

# Sanitycheck for patchdir
if exists "$patchdir/$CATEGORY/$PNVR/*.patch" || exists "$patchdir/$CATEGORY/$PNVR/*.patch"; then
	## Required to apply patches
	# Fetch only when we need to apply patches
	DEPEND+="
		build:
			sys-devel/patch
	"

	# Apply version specific patches
	if exists "$patchdir/$CATEGORY/$PNVR/*.patch"; then
		for p in "$patchdir/$CATEGORY/$PNVR/*.patch"; do
			# -b = Make backup files of patched files prior to patch
			# -p1 = strip /u/.. from patch
			# --directory = Switches directory prior to applying patches (required?)
			{ patch -b -p1 --directory="$WORKDIR/$PNAV" "$p" && exdebug "Applied patches from '$p' in '$WORKDIR/$PNAV'" ;} || die "Unable to apply patch $p in $WORKDIR"
		done
	elif ! exists "$patchdir/$CATEGORY/$PNVR/*.patch"; then
		exdebug "There are no patches in '$patchdir/$CATEGORY/$PNVR/*.patch', not applying"
	else
		die "Unexpected input in '$0' - 'PNVR/*.patch'"
	fi

	# Apply global patches
	if exists "$patchdir/$CATEGORY/$PN/*.patch"; then
		for p in "$patchdir/$CATEGORY/$PN/*.patch"; do
			# -b = Make backup files of patched files prior to patch
			# -p1 = strip /u/.. from patch
			# --directory = Switches directory prior to applying patches (required?)
			{ patch -b -p1 --directory="$WORKDIR/$PNAV" "$p" && exdebug "Applied patches from '$p' in '$WORKDIR/$PNAV'" ;} || die "Unable to apply patch $p in $WORKDIR"
		done
	else
		die "Unexpected input in '$0' - 'PN/*.patch'"
	fi
elif [ ! -d "$patchdir" ]; then
	einfo "Variable 'patchdir' with value '$patchdir' is not valid directory, skipping applying user patches since there is nothing to be applied"
else
	die "Unexpected input in '$0' - logic for applying patches"
fi
