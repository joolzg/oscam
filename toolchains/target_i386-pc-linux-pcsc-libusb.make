# Linux native with PCSC & libusb (smartreader)
i386-pc-linux-pcsc-libusb:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$(subst i386,$(shell uname --machine),$@) \
		USE_LIBUSB=1 \
		USE_PCSC=1 \
		OS_LIBS="-lrt" \
		DS_OPTS="-DOS_LINUX" \
