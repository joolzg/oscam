# ARM crosscompiler (big-endian)
cross-armBE-unknown-linux:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_LINUX -DARM -DALIGNMENT" \
		DS_CROSS=arm-linux- \
		DS_CC="gcc -mbig-endian" \
		DS_LD="ld -EB"

cross-armBE-unkown-linux: cross-armBE-unknown-linux
