cross-powerpc-tuxbox-linux:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		OS_LIBS="-ldl" \
		DS_CONFDIR=/var/tuxbox/config \
		DS_OPTS="-DOS_LINUX -DTUXBOX -DPPC" \
		DS_CROSS=powerpc-tuxbox-linux-gnu-
