# Cygwin native with libusb
# requires Visual Studio / Visual C++ for the winscard includes
i386-pc-cygwin-libusb:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		USE_LIBUSB=1 \
		OS_LIBS="-lSetupAPI -lOle32 -lshell32" \
		DS_OPTS="-DOS_CYGWIN32 -D_WIN32 -I /tmp/include -I ./cygwin"
