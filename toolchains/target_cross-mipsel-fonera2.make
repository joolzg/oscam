# Linux MIPS(LE) crosscompiler for La Fonera 2.0
cross-mipsel-fonera2:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		OS_LIBS="-Lopenssl-lib" \
		DS_OPTS="-Iopenssl-include -DOS_LINUX -DMIPSEL -DUCLIBC -static-libgcc" \
		DS_CROSS=mips-linux-
