# Linux native with PCSC
i386-pc-linux-pcsc:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$(subst i386,$(shell uname --machine),$@) \
		USE_PCSC=1 \
		DS_OPTS="-DOS_LINUX"
