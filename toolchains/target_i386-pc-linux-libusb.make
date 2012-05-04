# Linux native with libusb (smartreader)
i386-pc-linux-libusb:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$(subst i386,$(shell uname --machine),$@) \
		USE_LIBUSB=1 \
		OS_LIBS="-lrt" \
		DS_OPTS="-DOS_LINUX"
