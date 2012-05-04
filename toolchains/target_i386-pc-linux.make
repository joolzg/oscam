# Linux native
i386-pc-linux:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$(subst i386,$(shell uname --machine),$@) \
		DS_OPTS="-DOS_LINUX" \
