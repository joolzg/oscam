# FreeBSD 5.4 crosscompiler
cross-i386-pc-freebsd:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_FREEBSD -DBSD_COMP -static-libgcc" \
		DS_CROSS=i386-pc-freebsd5.4-
