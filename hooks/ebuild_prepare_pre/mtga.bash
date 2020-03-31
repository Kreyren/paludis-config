#!/usr/bin/env bash
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2020 under GPLv3 license <https://www.gnu.org/licenses/gpl-3.0.en.html> in 2019

# Workaround for bug https://bugs.winehq.org/show_bug.cgi?id=47479
if [ "$CATEGORY/$PN" = app-emulation/wine ]; then
	BUG_STATUS="$(curl https://bugs.winehq.org/show_bug.cgi?id=45546 2>/dev/null | grep "static_bug_status" | grep -oP "[^>]+")"

	if [ "$BUG_STATUS" != CLOSED ]; then
		exinfo "Working around bug 47479 for Magic The Gathering Arena for $PN"
		patch -b -p1 --directory="$WORKDIR/$PNAV" "/etc/paludis/hooks/ebuild_prepare_pre/MTGA" || die 1 "Hook '$0' was unable to apply patches for $PNVR"
	elif [ "$BUG_STATUS" = CLOSED ]; then
		exwarn "Winebug 47479 has been closed, no need to apply patches anymore"
	else
		die 256 "Unexpected happend while working around winebug 47479"
	fi
fi
