# Cygwin native
i386-pc-cygwin:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		DS_CONFDIR=. \
		DS_OPTS="-DOS_CYGWIN32 -I /tmp/include"
