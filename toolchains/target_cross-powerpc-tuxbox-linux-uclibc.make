# Tuxbox crosscompiler with uclibc
cross-powerpc-tuxbox-linux-uclibc:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_CONFDIR=/var/tuxbox/config \
		DS_OPTS="-DOS_LINUX -DTUXBOX -DPPC" \
		DS_CROSS=powerpc-tuxbox-linux-uclibc-
