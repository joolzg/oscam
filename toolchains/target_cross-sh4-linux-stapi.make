# sh4 crosscompiler with STAPI
cross-sh4-linux-stapi:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		OS_LIBS="-L./stapi -loscam_stapi" \
		DS_CONFDIR=/var/tuxbox/config \
		DS_OPTS="-DOS_LINUX -DSH4 -DWITH_STAPI -DTUXBOX -DSCI_DEV" \
		DS_CROSS=sh4-linux-
