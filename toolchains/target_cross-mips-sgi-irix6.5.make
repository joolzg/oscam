# IRIX 6.5 crosscompiler
cross-mips-sgi-irix6.5:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_IRIX -DOS_IRIX65 -static-libgcc" \
		DS_CROSS=mips-sgi-irix6.5-
