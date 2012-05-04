# Cygwin crosscompiler
cross-i386-pc-cygwin:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		DS_OPTS="-DOS_CYGWIN32 -static" \
		DS_CROSS=i686-pc-cygwin-
