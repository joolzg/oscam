# Linux MIPS crosscompiler with ucLibc
cross-mips-router-linux-uclibc:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		DS_OPTS="-DOS_LINUX -DMIPS -DUCLIBC -DUSE_GPIO -static-libgcc" \
		DS_CROSS=mips-linux-uclibc-
