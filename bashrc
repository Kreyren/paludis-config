# shellcheck shell=bash # Paludis doesn't expect shebang here
# shellcheck disable=SC2034 # Appears unused is invalid since this is recognized by paludis

COMMON_FLAGS="-O2 -march=sandybridge -pipe"

i686_pc_linux_gnu_CFLAGS="$COMMON_FLAGS"
i686_pc_linux_gnu_CXXFLAGS="$COMMON_FLAGS"

x86_64_pc_linux_gnu_CFLAGS="$COMMON_FLAGS"
x86_64_pc_linux_gnu_CXXFLAGS="$COMMON_FLAGS"

i686_pc_linux_gnu_FFLAGS="$COMMON_FLAGS"
x86_64_PC_linux_gnu_FFLAGS="$COMMON_FLAGS"

i686_pc_linux_gnu_FCLAGS="$COMMON_FLAGS"
x86_64_PC_linux_gnu_FCLAGS="$COMMON_FLAGS"

i686_pc_linux_gnu_FDFLAGS="-Wl,-O2 -Wl, -pthread -lpthread"
x86_64_pc_linux_gnu_FDFLAGS="-Wl,-O2 -Wl, -pthread -lpthread"

CHOST="x86_64-pc-linux-gnu"
CBUILD="x86_64-pc-linux-gnu"

# FIXME: Investigate
#RUSTFLAGS="-C target-cpu=native -C opt-level=3"

export PALUDIS_PATCHDIR="$ROOT/etc/paludis/paludis"

# Output helpers
exinfo() {
	printf 'INFO: %s\n' "$1"
}
exwarn() {
	printf 'WARN: %s\n' "$1"
}
exerror() {
	printf 'ERROR: %s\n' "$1"
}

exfixme() {
	[ -z "$IGNORE_FIXME" ] && printf 'FIXME: %s\n' "$1"
}


# Annoyingly paludis interprets this as syntax error
#die() {
#	case "$1" in
#		# FIXME: Add standardization for exit codes
#		[1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]) printf 'FATAL: %s\n' "$2" ;;
#		*)
#			exfixme "Package $PNVR is using die() function without specified exit code"
#			printf 'FATAL: %s\n' "$1"
#	esac
#}

exdebug() {
	# Ugly, but this way it doesn't have to process following if statement on runtime
	[ -n "$DEBUG" ] && if [ -z "$EDEBUG_PREFIX" ]; then
		printf "$EDEBUG_PREFIX: %s\\n" "$1"
		return 0
	elif [ -z "$EDEBUG_PREFIX" ]; then
		printf 'DEBUG: %s\n' "$1"
		return 0
	else
		# Do not depend on die() here
		printf 'FATAL: %s\n' "Unexpected happend while exporting edebug message"
		exit 255
	fi
}

# (Exheredrey) Info to resolve these kinds of conflicts was not provided, this is my solution. Provide required info to resolve if needed.
# TODO: Update docs for shimming
# TODO: Implement this in paludis
bannedrey() {
	: "
		Shim banned function

		Wrapper to symlink required commands in case they are banned by distribution
		- Creates a $SHIMDIR
		- Symlinks $SHIMPATH/$command in SHIMDIR/$command
		- Output warning if $command is not longer banned

		This may require exporting $PATH with $SHIMDIR, note that SMIDIR is not recognized outside of this function
			export PATH="$PATH:$SHIMDIR"
	"
	local SHIMDIR="$WORKBASE/shims"
	# INFO: This is to resolve SC2155 while not exporting SHIMPATH outside of the function
	local SHIMPATH
	SHIMPATH="/usr/host/bin/$(exhost --tool-prefix)$command"
	local BANDIR="/usr/share/exherbo/banned_by_distribution/"
	local command="$1"

	# Check if command is banned
	if [ -e "$BANDIR/$command" ]; then
		ewarn "Command '$command' is banned by distribution, shimming.."

		# Create a SHIMDIR
		if [ ! -d "$SHIMDIR" ]; then
			mkdir "$SHIMDIR" || die "Unable to make a new directory in '$SHIMDIR'"
		elif [ -f "$SHIMDIR" ]; then
			die "bug: pathname '$SHIMDIR' points to a file where directory is expected, did upstream made a new file that conflicts with exlib logic?"
		elif [ -d "$SHIMDIR" ]; then
			true
		else
			die "Unexpected happend in ${FUNCNAME[0]} while checking for $SHIMDIR"
		fi

		# Shim
		if [ ! -h "$SHIMDIR/$command" ]; then
			ln -s "$SHIMPATH$command" "$SHIMDIR/$command" || die "Unable to make a symlink from $SHIMPATH$command' in '$SHIMDIR/$command' used for shimming."
		elif [ -h "$SHIMDIR/$command" ]; then
			true
		else
			die "Unexpected happend in ${FUNCNAME[0]} - Shimming"
		fi

		# Export PATH
		case "$PATH" in
			*:$SHIMDIR) exdebug "PATH '$PATH' already contains '$SHIMDIR', skipping export" ;;
			*)
				export PATH="$SHIMDIR:$PATH"
				debug "SHIMDIR has been exported in PATH : '$PATH'"
		esac

		# Self-check
		"$command" --version &>/dev/null || die "bug: ${FUNCNAME[0]} logic didn't export shim correctly"

	elif [ ! -e "$BANDIR/$command" ]; then
		ewarn "bug: Command '$command' is not banned, skipping shimming.."
	else
		die "Unexpected in ${FUNCNAME[0]}"
	fi
}
