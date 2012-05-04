# HP/UX 10.20 native
hppa1.1-hp-hpux10.20:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_HPUX -DOS_HPUX10 -D_XOPEN_SOURCE_EXTENDED"
