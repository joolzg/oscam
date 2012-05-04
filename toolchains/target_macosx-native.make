# MacOSX native
macosx-native:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		USE_PCSC=1 \
		PCSC= \
		PCSC_DEFS="-DHAVE_PCSC=1" \
		DS_OPTS="-DOS_MACOSX -DNEED_DAEMON -DHAVE_PTHREAD_H -m32 -mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -finline-functions -fomit-frame-pointer" \
		DS_LDFLAGS="-framework PCSC -mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk" \
