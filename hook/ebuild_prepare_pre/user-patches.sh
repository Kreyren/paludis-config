## Copyright 2019 Jacob Hrbek <kreyren@rixotstudio.cz>
## Distributed under the terms of the GNU General Public License v3
# Based in part upon 'https://github.com/Keruspe/paludis-config/blob/exherbo/hooks/ebuild_prepare_pre/patches.bash' from Exherbo, which is:
# 		Unlicenced

# This file is used for sourcing from $PALUDIS_HOME/hook/ebuild_prepare_pre/foo.sh

# Export edebug
require exdebug

if [ "$DEBUG_INIT" != kreyren ]; then
	ewarn "Exlib 'edebug' from kreyren is not sourced, debugging messages are set on default"
	exdebug() { printf '%s\n' "DEBUG(exported): $@" ;}
elif [ "$DEBUG_INIT" = kreyren ]; then
	# Output in build log since this might be a factor in debuging for upstream
	einfo "User-patches hook made by kreyren has been sourced"
fi

# Purpose: Apply user-patches from patch directory
# Maintainer: Jacob Hrbek <kreyren@rixotstudio.cz>
# Usage: grabs patches from defined patchdir variable path and applies them
# References:
# - gitlab issue (https://gitlab.exherbo.org/kreyren/exheredrey/issues/84)
# - inspiration (https://github.com/Keruspe/paludis-config/blob/exherbo/hooks/ebuild_prepare_pre/patches.bash)
## Make sure that PALUDIS_HOME is exported to expected
if [ -s "$PALUDIS_HOME/options.conf" ]; then
	exdebug "File '$PALUDIS_HOME/options' exists and is not blank, assuming valid paludis directory"
elif [ ! -e "$PALUDIS_HOME/options.conf" ]; then
	die "Variable 'PALUDIS_HOME' with value '$PALUDIS_HOME' is not valid paludis directory since options.conf with size greater then zero is not present."
fi

## Directory from which we are going to read patches
if [ -z "$patchdir" ]; then
	exdebug "Variable 'patchdir' with value '$patchdir' is blank, sourcing default value '$PALUDIS_HOME/patches/$CATEGORY/$PNAV'"
	patchdir="$PALUDIS_HOME/patches/$CATEGORY/$PN"
elif [ -n "$patchdir" ]; then
	exdebug "Variable 'patchdir' with value '$patchdir' is not blank, assuming user override"
fi

# Sanitycheck for patchdir
[ ! -d "$patchdir" ] && die "Variable 'patchdir' with value '$patchdir' is not valid directory which is unexpected and required for '$@', bug?"

## Required to apply patches
DEPEND+="
	build+run:
		sys-devel/patch
"

## Core
for p in "$patchdir/*.patch"; do
	# -b = Make backup files of patched files prior to patch
	# -p1 = Some compatibility thing
	# --directory = Switches directory prior to applying patches (required?)
	{ patch -b -p1 --directory="$WORKDIR/$PNAV" "$p" && exdebug "Applied patches from '$p' in '$WORKDIR/$PNAV'" ;} || die "Unable to apply patch $p in $WORKDIR"
done
