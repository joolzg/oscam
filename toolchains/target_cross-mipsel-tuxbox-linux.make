# Linux MIPS(LE) crosscompiler
cross-mipsel-tuxbox-linux:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		DS_CONFDIR=/var/tuxbox/config \
		DS_OPTS="-DOS_LINUX -DTUXBOX -DMIPSEL -static-libgcc" \
		DS_CROSS=mipsel-linux-

cross-mipsel-tuxbox-linux-glibc: cross-mipsel-tuxbox-linux
