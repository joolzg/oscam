# sh4 crosscompiler
cross-sh4-linux:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		DS_CONFDIR=/var/tuxbox/config \
		DS_OPTS="-DOS_LINUX -DSH4 -DTUXBOX" \
		DS_CROSS=sh4-linux-
