# OpenSolaris native compiler
opensolaris:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		OS_LIBS="-lnsl" \
		DS_OPTS="-DOS_SOLARIS -DOS_SOLARIS7 -DBSD_COMP -static-libgcc" \
		DS_LDFLAGS="-lsocket"
