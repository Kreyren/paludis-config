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
