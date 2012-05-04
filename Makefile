SHELL	= /bin/sh

DS_CONFDIR ?= /usr/local/etc

VER	= $(subst ",,$(filter-out \#define CS_VERSION,$(shell grep CS_VERSION globals.h)))$(shell test -f `which svnversion` && svnversion -n . | awk 'BEGIN {FS = ":"} {print $$1}' | sed 's/[MS]$$//' | sed 's/exported/0/;s| |_|g' || echo -n 0 )
SVN_REV = $(shell test -f `which svnversion` && svnversion -n . | awk 'BEGIN {FS = ":"} {print $$1}' | sed 's/[MS]$$//' | sed 's/exported/0/;s| |_|g' || echo -n 0 )

export VER SVN_REV DS_CONFDIR

linux:	i386-pc-linux
debug: i386-pc-linux-debug
linux-pcsc:	i386-pc-linux-pcsc
freebsd:	i386-pc-freebsd
tuxbox:	cross-powerpc-tuxbox-linux
tripledragon: cross-powerpc-405-linux
win:	cross-i386-pc-cygwin
cygwin: i386-pc-cygwin
macosx: macosx-native

std:	linux \
	macosx \
	cross-i386-pc-cygwin \
	cross-powerpc-tuxbox-linux \
	cross-powerpc-405-linux \
	cross-i386-pc-freebsd \
	cross-arm-nslu2-linux \
	cross-mipsel-router-linux-uclibc927 \
	cross-mipsel-router-linux-uclibc928 \
	cross-mipsel-router-linux-uclibc929 \
	cross-mipsel-router-linux-uclibc929-static \
	cross-mipsel-tuxbox-linux-glibc \
	cross-mipsel-fonera2 \
	cross-sh4-linux

all:	\
	cross-sparc-sun-solaris2.7 \
	cross-rs6000-ibm-aix4.2 \
	cross-mips-sgi-irix6.5


dist:	std
	@cd Distribution && tar cvf "../oscam$(VER).tar" *
	@bzip2 -9f "oscam$(VER).tar"

extra:	all
	@cd Distribution && tar cvf "../oscam$(VER)-extra.tar" *
	@bzip2 -9f "oscam$(VER)-extra.tar"

clean:
	@-rm -rf oscam-ostype.h lib Distribution/oscam-*

tar:	clean
	@tar cvf "oscam$(VER)-src.tar" Distribution Make* *.c *.h cscrypt csctapi
	@bzip2 -9f "oscam$(VER)-src.tar"

nptar:	clean
	@tar cvf "oscam$(VER)-nonpublic-src.tar" Distribution Make* *.c *.np *.h cscrypt csctapi csgbox
	@bzip2 -9f "oscam$(VER)-nonpublic-src.tar"

######################################################################
#
#	LINUX native
#
######################################################################
i386-pc-linux:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$(subst i386,$(shell uname --machine),$@) \
		DS_OPTS="-DOS_LINUX" \

i386-pc-linux-debug:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$(subst i386,$(shell uname --machine),$@) \
		OS_LIBS="-lrt" \
		DEBUG=1 \
		DS_OPTS="-DOS_LINUX" \

######################################################################
#
#	LINUX native with libusb (smartreader)
#
######################################################################
i386-pc-linux-libusb:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$(subst i386,$(shell uname --machine),$@) \
		USE_LIBUSB=1 \
		OS_LIBS="-lrt" \
		DS_OPTS="-DOS_LINUX"

######################################################################
#
#	LINUX native with PCSC
#
######################################################################
i386-pc-linux-pcsc:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$(subst i386,$(shell uname --machine),$@) \
		USE_PCSC=1 \
		DS_OPTS="-DOS_LINUX"

######################################################################
#
#	LINUX native with PCSC & libusb (smartreader)
#
######################################################################
i386-pc-linux-pcsc-libusb:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$(subst i386,$(shell uname --machine),$@) \
		USE_LIBUSB=1 \
		USE_PCSC=1 \
		OS_LIBS="-lrt" \
		DS_OPTS="-DOS_LINUX" \

######################################################################
#
#       MacOSX native
#
######################################################################
macosx-native:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		USE_PCSC=1 \
		PCSC= \
		PCSC_DEFS="-DHAVE_PCSC=1" \
		DS_OPTS="-DOS_MACOSX -DNEED_DAEMON -DHAVE_PTHREAD_H -m32 -mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -finline-functions -fomit-frame-pointer" \
		DS_LDFLAGS="-framework PCSC -mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk" \

######################################################################
#
#       MacOSX native with libusb (smartreader)
#
######################################################################
macosx-libusb:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		USE_LIBUSB=1 \
		USE_PCSC=1 \
		PCSC= \
		PCSC_DEFS="-DHAVE_PCSC=1" \
		DS_OPTS="-DOS_MACOSX -DNEED_DAEMON -DHAVE_PTHREAD_H -m32 -mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -finline-functions -fomit-frame-pointer" \
		DS_LDFLAGS="-framework PCSC -mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -Wl,-framework -Wl,IOKit -Wl,-framework -Wl,CoreFoundation -Wl,-prebind -no-undefined" \


######################################################################
#
#	FreeBSD native
#
######################################################################
i386-pc-freebsd:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_FREEBSD -DBSD_COMP -static-libgcc" \

######################################################################
#
#	FreeBSD 5.4 crosscompiler
#
######################################################################
cross-i386-pc-freebsd:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_FREEBSD -DBSD_COMP -static-libgcc" \
		DS_CROSS=i386-pc-freebsd5.4-

######################################################################
#
#	Tuxbox crosscompiler
#
######################################################################
cross-powerpc-tuxbox-linux:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		OS_LIBS="-ldl" \
		DS_CONFDIR=/var/tuxbox/config \
		DS_OPTS="-DOS_LINUX -DTUXBOX -DPPC" \
		DS_CROSS=powerpc-tuxbox-linux-gnu-

cross-powerpc-tuxbox-linux-uclibc:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_CONFDIR=/var/tuxbox/config \
		DS_OPTS="-DOS_LINUX -DTUXBOX -DPPC" \
		DS_CROSS=powerpc-tuxbox-linux-uclibc-

######################################################################
#
#	TripleDragon crosscompiler
#
######################################################################
cross-powerpc-405-linux:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		OS_LIBS="-ldl" \
		DS_CONFDIR=/var/tuxbox/config \
		DS_OPTS="-DOS_LINUX -DTRIPLEDRAGON -DSTB04SCI" \
		DS_CROSS=powerpc-405-linux-gnu-

######################################################################
#
#	sh4 crosscompiler
#
######################################################################
cross-sh4-linux:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		DS_CONFDIR=/var/tuxbox/config \
		DS_OPTS="-DOS_LINUX -DSH4 -DTUXBOX" \
		DS_CROSS=sh4-linux-

cross-sh4-linux-stapi:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		OS_LIBS="-L./stapi -loscam_stapi" \
		DS_CONFDIR=/var/tuxbox/config \
		DS_OPTS="-DOS_LINUX -DSH4 -DWITH_STAPI -DTUXBOX -DSCI_DEV" \
		DS_CROSS=sh4-linux-

######################################################################
#
#	Cygwin crosscompiler
#
######################################################################
cross-i386-pc-cygwin:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		DS_OPTS="-DOS_CYGWIN32 -static" \
		DS_CROSS=i686-pc-cygwin-

######################################################################
#
#	Cygwin native
#
######################################################################
i386-pc-cygwin:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		DS_CONFDIR=. \
		DS_OPTS="-DOS_CYGWIN32 -I /tmp/include" \


######################################################################
#
#	Cygwin native with PCSC
#
######################################################################
i386-pc-cygwin-pcsc:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		OS_LIBS="-lwinscard" \
		USE_PCSC=1 \
		PCSC_LIB= \
		PCSC_DEFS="-DHAVE_PCSC=1" \
		DS_OPTS="-DOS_CYGWIN32 -D_WIN32 -I /tmp/include -I ./cygwin -I/usr/include/w32api" \
		DS_LDFLAGS="-L/cygdrive/c/WINDOWS/system32/" \

######################################################################
#
#	Cygwin native with libusb
#
# 	requires Visual Studio / Visual C++ for the winscard includes
######################################################################
i386-pc-cygwin-libusb:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		USE_LIBUSB=1 \
		OS_LIBS="-lSetupAPI -lOle32 -lshell32" \
		DS_OPTS="-DOS_CYGWIN32 -D_WIN32 -I /tmp/include -I ./cygwin" \

######################################################################
#
#	Solaris 7 crosscompiler
#
######################################################################
cross-sparc-sun-solaris2.7:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_SOLARIS -DOS_SOLARIS7 -DBSD_COMP -static-libgcc" \
		DS_LDFLAGS="-lsocket" \
		DS_CROSS=sparc-sun-solaris2.7-

######################################################################
#
#	OpenSolaris native compiler
#
######################################################################
opensolaris:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		OS_LIBS="-lnsl" \
		DS_OPTS="-DOS_SOLARIS -DOS_SOLARIS7 -DBSD_COMP -static-libgcc" \
		DS_LDFLAGS="-lsocket" \

######################################################################
#
#	AIX 4.2 crosscompiler
#
######################################################################
cross-rs6000-ibm-aix4.2:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		LIB_PTHREAD="-lpthreads" \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_AIX -DOS_AIX42 -static-libgcc" \
		DS_CROSS=rs6000-ibm-aix4.2-

######################################################################
#
#	IRIX 6.5 crosscompiler
#
######################################################################
cross-mips-sgi-irix6.5:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_IRIX -DOS_IRIX65 -static-libgcc" \
		DS_CROSS=mips-sgi-irix6.5-

######################################################################
#
#	Linux MIPS(LE) crosscompiler with ucLibc 0.9.27
#
######################################################################
cross-mipsel-router-linux-uclibc927:
	@-mipsel-linux-uclibc-setlib 0.9.27
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_LINUX -DMIPSEL -DUCLIBC -DUSE_GPIO -static-libgcc" \
		DS_CROSS=mipsel-linux-uclibc-

######################################################################
#
#	Linux MIPS(LE) crosscompiler with ucLibc 0.9.28
#
######################################################################
cross-mipsel-router-linux-uclibc928:
	@-mipsel-linux-uclibc-setlib 0.9.28
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		DS_OPTS="-DOS_LINUX -DMIPSEL -DUCLIBC -DUSE_GPIO -static-libgcc" \
		DS_CROSS=mipsel-linux-uclibc-

######################################################################
#
#	Linux MIPS(LE) crosscompiler with ucLibc 0.9.29
#
######################################################################
cross-mipsel-router-linux-uclibc929:
	@-mipsel-linux-uclibc-setlib 0.9.29
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		DS_OPTS="-DOS_LINUX -DMIPSEL -DUCLIBC -DUSE_GPIO -static-libgcc" \
		DS_CROSS=mipsel-linux-uclibc-

######################################################################
#
#	Linux MIPS(LE) crosscompiler with ucLibc 0.9.29 (static)
#
######################################################################
cross-mipsel-router-linux-uclibc929-static:
	@-mipsel-linux-uclibc-setlib 0.9.29
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		DS_OPTS="-DOS_LINUX -DMIPSEL -DUCLIBC -DUSE_GPIO -static-libgcc" \
		DS_CROSS=mipsel-linux-uclibc-

######################################################################
#
#	Linux MIPS crosscompiler with ucLibc 0.9.30
#
######################################################################
cross-mips-router-linux-uclibc930:
	@-mips-linux-uclibc-setlib 0.9.30
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		DS_OPTS="-DOS_LINUX -DMIPS -DUCLIBC -DUSE_GPIO -static-libgcc" \
		DS_CROSS=mips-linux-uclibc-

######################################################################
#
#	Linux MIPS crosscompiler with ucLibc 0.9.31
#
######################################################################
cross-mips-router-linux-uclibc931:
	@-mips-linux-uclibc-setlib 0.9.31
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		DS_OPTS="-DOS_LINUX -DMIPS -DUCLIBC -DUSE_GPIO -static-libgcc" \
		DS_CROSS=mips-linux-uclibc-

######################################################################
#
#	Linux MIPS(LE) crosscompiler for La Fonera 2.0
#
######################################################################
cross-mipsel-fonera2:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		OS_LIBS="-Lopenssl-lib" \
		DS_OPTS="-Iopenssl-include -DOS_LINUX -DMIPSEL -DUCLIBC -static-libgcc" \
		DS_CROSS=mips-linux-

######################################################################
#
#	Linux MIPS(LE) crosscompiler with glibc (DM7025)
#
######################################################################
cross-mipsel-tuxbox-linux-glibc:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		DS_CONFDIR=/var/tuxbox/config \
		DS_OPTS="-DOS_LINUX -DTUXBOX -DMIPSEL -static-libgcc" \
		DS_CROSS=mipsel-linux-glibc-

cross-mipsel-tuxbox-linux:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		DS_CONFDIR=/var/tuxbox/config \
		DS_OPTS="-DOS_LINUX -DTUXBOX -DMIPSEL -static-libgcc" \
		DS_CROSS=mipsel-linux-

######################################################################
#
#	HP/UX 10.20 native
#
######################################################################
hppa1.1-hp-hpux10.20:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_HPUX -DOS_HPUX10 -D_XOPEN_SOURCE_EXTENDED" \

######################################################################
#
#	OSF5.1 native
#
######################################################################
alpha-dec-osf5.1:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_OSF -DOS_OSF5"

######################################################################
#
#	ARM crosscompiler (big-endian)
#
######################################################################
cross-arm-nslu2-linux:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_LINUX -DARM -DALIGNMENT" \
		DS_CROSS=armv5b-softfloat-linux-

######################################################################
#
#	ARM crosscompiler (big-endian)
#
######################################################################
cross-armBE-unknown-linux:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_LINUX -DARM -DALIGNMENT" \
		DS_CROSS=arm-linux- \
		DS_CC="gcc -mbig-endian" \
		DS_LD="ld -EB"

cross-armBE-unkown-linux: cross-armBE-unknown-linux

######################################################################
#
#	ARM crosscompiler (little-endian)
#
######################################################################
cross-armLE-unknown-linux:
	@-$(MAKE) --no-print-directory -f Maketype \
		DS_TYPE=$@ \
		NO_LIBCRYPTO=1 \
		DS_OPTS="-DOS_LINUX -DARM -DALIGNMENT" \
		DS_CROSS=arm-linux- \
		DS_CC="gcc -mlittle-endian" \
		DS_LD="ld -EL"

cross-armLE-unkown-linux: cross-armLE-unknown-linux
