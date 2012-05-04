# Linux MIPS(LE) crosscompiler with ucLibc
cross-mipsel-router-linux-uclibc:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_LINUX -DMIPSEL -DUCLIBC -DUSE_GPIO -static-libgcc" \
		DS_CROSS=mipsel-linux-uclibc-

cross-mipsel-router-linux-uclibc927: cross-mipsel-router-linux-uclibc

cross-mipsel-router-linux-uclibc928: cross-mipsel-router-linux-uclibc

cross-mipsel-router-linux-uclibc929: cross-mipsel-router-linux-uclibc

cross-mipsel-router-linux-uclibc929-static: cross-mipsel-router-linux-uclibc
