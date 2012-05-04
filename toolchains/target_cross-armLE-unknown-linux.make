# ARM crosscompiler (little-endian)
cross-armLE-unknown-linux:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_LINUX -DARM -DALIGNMENT" \
		DS_CROSS=arm-linux- \
		DS_CC="gcc -mlittle-endian" \
		DS_LD="ld -EL"

cross-armLE-unkown-linux: cross-armLE-unknown-linux
