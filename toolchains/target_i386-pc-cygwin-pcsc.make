# Cygwin native with PCSC
i386-pc-cygwin-pcsc:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		OS_LIBS="-lwinscard" \
		USE_PCSC=1 \
		PCSC_LIB= \
		PCSC_DEFS="-DHAVE_PCSC=1" \
		DS_OPTS="-DOS_CYGWIN32 -D_WIN32 -I /tmp/include -I ./cygwin -I/usr/include/w32api" \
		DS_LDFLAGS="-L/cygdrive/c/WINDOWS/system32/"
