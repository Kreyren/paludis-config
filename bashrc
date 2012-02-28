CHOST="x86_64-pc-linux-gnu"
MAKEOPTS="-j9"
CUSTOM_CFLAGS="-march=native -O3 -pipe"
CFLAGS+=" ${CUSTOM_CFLAGS}"
CXXFLAGS+=" ${CUSTOM_CFLAGS}"
LDFLAGS+=" -Wl,-O2"
I_WANT_GNOME_3_3_X=yes

case "${CATEGORY}/${PN}" in
    "sys-apps/paludis")
        CXXFLAGS+=" -g -ggdb3"
        ;;
    "net-libs/neon")
        LDFLAGS+=" -lgcrypt"
        ;;
esac

