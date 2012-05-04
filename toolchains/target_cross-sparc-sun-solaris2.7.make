# Solaris 7 crosscompiler
cross-sparc-sun-solaris2.7:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_SOLARIS -DOS_SOLARIS7 -DBSD_COMP -static-libgcc" \
		DS_LDFLAGS="-lsocket" \
		DS_CROSS=sparc-sun-solaris2.7-
