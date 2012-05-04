# OSF5.1 native
alpha-dec-osf5.1:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_OSF -DOS_OSF5"
