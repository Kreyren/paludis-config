#!/usr/bin/env bash
# Originally created by Marc-Antoine "Keruspe" Perennou <Marc-Antoine@Perennou.com> from Exherbo Linux as unlicensed - https://github.com/Keruspe/paludis-config/blob/exherbo/hooks/ebuild_prepare_pre/patches.bash
# Rewritten by Jacob Hrbek <kreyren@rixotstudio.cz> in 2019 under GPLv3 license <https://www.gnu.org/licenses/gpl-3.0.en.html> in 2019
# Maintained by Jacob Hrbek <kreyren@rixotstudio.cz> in 2020

# NOTICE: shellcheck version higger then 0.7.0 is expected to be used for linting
# shellcheck shell=bash # Written to be implemented for POSIX later in the development

###! This hook is used for providing a backend for applying user-patches through directory defined in environment variable PALUDIS_PATCHDIR
###! NOTICE: This hook is designed to be present in /etc/paludis/hooks/ebuild_metadata_pre because we are defining functions for other phases
###! Checks files with extension 'patch' based on definitions used in patchfile array
###! By default PALUDIS_PATCHDIR is using /etc/paludis/patches for definitions
###! This depends on functions defined in PaludisDir/bashrc for output

# FIXME: Check for expected shell
# Define where do we look for patches
patchfile=(
	"$PALUDIS_PATCHDIR/$CATEGORY/$PN/*.patch"
	"$PALUDIS_PATCHDIR/$CATEGORY/$PNVR/*.patch"
	"/etc/paludis/hooks/ebuild_prepare_pre/MTGA/*.patch"
)

# Make sure that we have patch if we need it
hook_run_ebuild_variable_post() {
	# We need 'sys-devel/patch' added in DEPEND if we expect to apply patches
	if [ -n "${patchfile[*]}" ]; then
		# FIXME-QA(Kreyren): I did not check if this is a valid syntax
		DEPEND+="build: sys-devel/patch"
	elif [ -z "${patchfile[*]}" ]; then
		exdebug "Not using sys-devel/patch for applying patches since there is not any"
	else
		die 256 "Unexpected happend while checking for existence of any patches to decide weather we need 'sys-devel/patch'"
	fi
}

hook_run_ebuild_prepare_pre() {
	# Process PALUDIS_PATCHDIR env variable
	if [ -z "$PALUDIS_PATCHDIR" ]; then
		export PALUDIS_PATCHDIR="/etc/paludis/patches"
		exinfo "Enviromental variable PALUDIS_PATCHDIR is blank, using $PALUDIS_PATCHDIR for user patches"
	elif [ -n "$PALUDIS_PATCHDIR" ]; then
		exdebug "Hook '$0' is using '$PALUDIS_PATCHDIR' as PALUDIS_PATCHDIR"
	else
		die 256 "Unexpected happend while processing PALUDIS_PATCHDIR environment variable"
	fi

	# Check if there are any patches present, if yes apply them
	for patch in "${patchfile[@]}"; do
		if [ -n "$patch" ]; then
			exinfo "Applying user patch '$patch' for package '$CATEGORY/$PNVR'"
			# CORE
			patch -b -p1 --directory="$WORKDIR/$PNAV" "$PNVR" || die 1 "Hook '$0' was unable to apply patches for $PNVR"
			exdebug "Applied patch '$patch' for package '$CATEGORY/$PNVR'"
		elif [ -z "$patch" ]; then
			exdebug "There are no user patches for package '$CATEGORY/$PNVR'"
		else
			die 256 "Unexpected happend while processing patches in hook '$0'"
		fi
	done
}
