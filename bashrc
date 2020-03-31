# shellcheck shell=sh # Paludis doesn't accept shebang here
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
CBUILD='x86_64-pc-linux-gnu'

# FIXME: Investigate
#RUSTFLAGS="-C target-cpu=native -C opt-level=3"

export PALUDIS_PATCHDIR="/bedrock/strata/exherbo/etc/paludis/paludis"

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
die() {
	case "$1" in
		# FIXME: Add standardization for exit codes
		[1-255]) printf 'FATAL: %s\n' "$2" ;;
		*)
			exfixme "Package $PNVR is using die() function without specified exit code"
			printf 'FATAL: %s\n' "$1"
	esac
}

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
