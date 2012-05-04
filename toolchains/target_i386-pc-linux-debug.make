# Linux native
i386-pc-linux-debug:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$(subst i386,$(shell uname --machine),$@) \
		OS_LIBS="-lrt" \
		DEBUG=1 \
		DS_OPTS="-DOS_LINUX"
