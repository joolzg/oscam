# AIX 4.2 crosscompiler
cross-rs6000-ibm-aix4.2:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		LIB_PTHREAD="-lpthreads" \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_AIX -DOS_AIX42 -static-libgcc" \
		DS_CROSS=rs6000-ibm-aix4.2-
