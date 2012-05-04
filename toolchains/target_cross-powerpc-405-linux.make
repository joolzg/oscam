# TripleDragon crosscompiler
cross-powerpc-405-linux:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		OS_LIBS="-ldl" \
		DS_CONFDIR=/var/tuxbox/config \
		DS_OPTS="-DOS_LINUX -DTRIPLEDRAGON -DSTB04SCI" \
		DS_CROSS=powerpc-405-linux-gnu-
