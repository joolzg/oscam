# ARM crosscompiler (big-endian)
cross-arm-nslu2-linux:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_LINUX -DARM -DALIGNMENT" \
		DS_CROSS=armv5b-softfloat-linux-
