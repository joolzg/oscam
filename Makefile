SHELL	= /bin/sh

VER	= $(subst ",,$(filter-out \#define CS_VERSION,$(shell grep CS_VERSION globals.h)))$(shell test -f `which svnversion` && svnversion -n . | awk 'BEGIN {FS = ":"} {print $$1}' | sed 's/[MS]$$//' | sed 's/exported/0/;s| |_|g' || echo -n 0 )
SVN_REV=""$(shell test -f `which svnversion` && svnversion -n . | awk 'BEGIN {FS = ":"} {print $$1}' | sed 's/[MS]$$//' | sed 's/exported/0/;s| |_|g' || echo -n 0 )""

CS_CONFDIR = '\"/usr/local/etc\"'

export VER

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
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst i386,$(shell uname --machine),$(subst cross-,,$@)) \
		OS_LIBS="-lcrypto -lm" \
		DS_OPTS="-O2 -DOS_LINUX -DCS_CONFDIR=${CS_CONFDIR} -DWITH_LIBCRYPTO -pthread -Winline -Wall -Wextra -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \

i386-pc-linux-debug:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst i386,$(shell uname --machine),$(subst cross-,,$@)) \
		OS_LIBS="-lcrypto -lm -lrt" \
		DS_OPTS="-O0 -DHAVE_DVBAPI -ggdb -pthread -DOS_LINUX -DCS_CONFDIR=${CS_CONFDIR} -DWITH_LIBCRYPTO -Winline -Wall -Wextra -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \

######################################################################
#
#	LINUX native with libusb (smartreader)
#
######################################################################
i386-pc-linux-libusb:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst i386,$(shell uname --machine),$(subst cross-,,$@)) \
        	LIBUSB="/usr/local/lib/libusb-1.0.a" \
		OS_LIBS="-lcrypto -lm -lrt" \
		DS_OPTS="-O2 -DOS_LINUX -DLIBUSB -DCS_CONFDIR=${CS_CONFDIR} -DWITH_LIBCRYPTO -pthread -Winline -Wall -Wextra -D'CS_SVN_VERSION="\"$(SVN_REV)\""' -I/usr/local/include" \

######################################################################
#
#	LINUX native with PCSC
#
######################################################################
i386-pc-linux-pcsc:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst i386,$(shell uname --machine),$(subst cross-,,$@)) \
		OS_LIBS="-lcrypto -lm" \
		OS_PTLI="-lpcsclite" \
		DS_OPTS="-O2 -DOS_LINUX -DCS_CONFDIR=${CS_CONFDIR} -DWITH_LIBCRYPTO -pthread -DHAVE_PCSC=1 -I/usr/include/PCSC -Winline -Wall -Wextra -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \

######################################################################
#
#	LINUX native with PCSC & libusb (smartreader)
#
######################################################################
i386-pc-linux-pcsc-libusb:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst i386,$(shell uname --machine),$(subst cross-,,$@)) \
        	LIBUSB="/usr/local/lib/libusb-1.0.a" \
		OS_LIBS="-lcrypto -lm -lrt" \
		OS_PTLI="-lpcsclite" \
		DS_OPTS="-O2 -DOS_LINUX -DLIBUSB -DCS_CONFDIR=${CS_CONFDIR} -DWITH_LIBCRYPTO -pthread -DHAVE_PCSC=1 -I/usr/include/PCSC -Winline -Wall -Wextra -D'CS_SVN_VERSION="\"$(SVN_REV)\""' -I/usr/local/include" \

######################################################################
#
#       MacOSX native
#
######################################################################
macosx-native:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lcrypto -lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_MACOSX -DNEED_DAEMON -DHAVE_PTHREAD_H -DCS_CONFDIR=${CS_CONFDIR} -DWITH_LIBCRYPTO -DHAVE_PCSC=1 -m32 -mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -Winline -Wall -Wextra -finline-functions -fomit-frame-pointer -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_LDFLAGS="-framework PCSC -mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk" \

######################################################################
#
#       MacOSX native with libusb (smartreader)
#
######################################################################
macosx-libusb:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		LIBUSB="/usr/local/lib/libusb-1.0.a" \
		OS_LIBS="-lcrypto -lm " \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_MACOSX -DNEED_DAEMON -DHAVE_PTHREAD_H -DCS_CONFDIR=${CS_CONFDIR} -DWITH_LIBCRYPTO -DHAVE_PCSC=1 -DLIBUSB -m32 -mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -Winline -Wall -Wextra -finline-functions -fomit-frame-pointer -D'CS_SVN_VERSION="\"$(SVN_REV)\""' -I/usr/local/include" \
		DS_LDFLAGS="-framework PCSC -mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -Wl,-framework -Wl,IOKit -Wl,-framework -Wl,CoreFoundation -Wl,-prebind -no-undefined" \


######################################################################
#
#	FreeBSD native
#
######################################################################
i386-pc-freebsd:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_FREEBSD -DBSD_COMP  -DCS_CONFDIR=${CS_CONFDIR} -static-libgcc -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \

######################################################################
#
#	FreeBSD 5.4 crosscompiler
#
######################################################################
cross-i386-pc-freebsd:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_FREEBSD -DBSD_COMP -DCS_CONFDIR=${CS_CONFDIR} -static-libgcc -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=i386-pc-freebsd5.4-

######################################################################
#
#	Tuxbox crosscompiler
#
######################################################################
cross-powerpc-tuxbox-linux:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lcrypto -ldl -lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_LINUX -DTUXBOX -DPPC -DWITH_LIBCRYPTO -DCS_CONFDIR='\"/var/tuxbox/config\"' -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=powerpc-tuxbox-linux-gnu-

cross-powerpc-tuxbox-linux-uclibc:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_LINUX -DTUXBOX -DPPC -DCS_CONFDIR='\"/var/tuxbox/config\"' -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=powerpc-tuxbox-linux-uclibc-

######################################################################
#
#	TripleDragon crosscompiler
#
######################################################################
cross-powerpc-405-linux:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lcrypto -ldl -lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_LINUX -DTRIPLEDRAGON -DWITH_LIBCRYPTO -DSTB04SCI -DCS_CONFDIR='\"/var/tuxbox/config\"' -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=powerpc-405-linux-gnu-

######################################################################
#
#	sh4 crosscompiler
#
######################################################################
cross-sh4-linux:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lcrypto -lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_LINUX -DSH4 -DTUXBOX -DWITH_LIBCRYPTO -DCS_CONFDIR='\"/var/tuxbox/config\"' -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=sh4-linux-

cross-sh4-linux-stapi:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lcrypto -lm -L./stapi -loscam_stapi" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_LINUX -DSH4 -DWITH_STAPI -DWITH_LIBCRYPTO -DTUXBOX -DSCI_DEV -DCS_CONFDIR='\"/var/tuxbox/config\"' -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=sh4-linux-

######################################################################
#
#	Cygwin crosscompiler
#
######################################################################
cross-i386-pc-cygwin:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lcrypto -lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_CYGWIN32 -DWITH_LIBCRYPTO -DCS_CONFDIR=${CS_CONFDIR} -static -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=i686-pc-cygwin-

######################################################################
#
#	Cygwin native
#
######################################################################
i386-pc-cygwin:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lcrypto -lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_CYGWIN32 -DWITH_LIBCRYPTO -DCS_CONFDIR='\".\"' -I /tmp/include -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \


######################################################################
#
#	Cygwin native with PCSC
#
######################################################################
i386-pc-cygwin-pcsc:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lcrypto -lm -lwinscard" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_CYGWIN32 -DWITH_LIBCRYPTO -D_WIN32 -DCS_CONFDIR=${CS_CONFDIR} -DHAVE_PCSC=1 -I /tmp/include -I ./cygwin -I/usr/include/w32api -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_LDFLAGS="-L/cygdrive/c/WINDOWS/system32/" \

######################################################################
#
#	Cygwin native with libusb
#
# 	requires Visual Studio / Visual C++ for the winscard includes
######################################################################
i386-pc-cygwin-libusb:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		LIBUSB="/usr/lib/libusb-1.0.a" \
		OS_LIBS="-lcrypto -lm -lSetupAPI -lOle32 -lshell32" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_CYGWIN32 -DWITH_LIBCRYPTO -D_WIN32 -DLIBUSB -DCS_CONFDIR=${CS_CONFDIR} -I /tmp/include -I ./cygwin -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \

######################################################################
#
#	Solaris 7 crosscompiler
#
######################################################################
cross-sparc-sun-solaris2.7:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_SOLARIS -DOS_SOLARIS7 -DBSD_COMP -DCS_CONFDIR=${CS_CONFDIR} -static-libgcc -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_LDFLAGS="-lsocket" \
		DS_CROSS=sparc-sun-solaris2.7-

######################################################################
#
#	OpenSolaris native compiler
#
######################################################################
opensolaris:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lcrypto -lnsl -lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_SOLARIS -DOS_SOLARIS7 -DWITH_LIBCRYPTO -DBSD_COMP -DCS_CONFDIR=${CS_CONFDIR} -static-libgcc -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_LDFLAGS="-lsocket" \

######################################################################
#
#	AIX 4.2 crosscompiler
#
######################################################################
cross-rs6000-ibm-aix4.2:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lm" \
		OS_PTLI="-lpthreads" \
		DS_OPTS="-O2 -DOS_AIX -DOS_AIX42 -DCS_CONFDIR=${CS_CONFDIR} -static-libgcc -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=rs6000-ibm-aix4.2-

######################################################################
#
#	IRIX 6.5 crosscompiler
#
######################################################################
cross-mips-sgi-irix6.5:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_IRIX -DOS_IRIX65 -DCS_CONFDIR=${CS_CONFDIR} -static-libgcc -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=mips-sgi-irix6.5-

######################################################################
#
#	Linux MIPS(LE) crosscompiler with ucLibc 0.9.27
#
######################################################################
cross-mipsel-router-linux-uclibc927:
	@-mipsel-linux-uclibc-setlib 0.9.27
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_LINUX -DMIPSEL -DUCLIBC -DUSE_GPIO -DCS_CONFDIR=${CS_CONFDIR} -static-libgcc -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=mipsel-linux-uclibc-

######################################################################
#
#	Linux MIPS(LE) crosscompiler with ucLibc 0.9.28
#
######################################################################
cross-mipsel-router-linux-uclibc928:
	@-mipsel-linux-uclibc-setlib 0.9.28
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lcrypto -lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_LINUX -DMIPSEL -DWITH_LIBCRYPTO -DUCLIBC -DUSE_GPIO -DCS_CONFDIR=${CS_CONFDIR} -static-libgcc -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=mipsel-linux-uclibc-

######################################################################
#
#	Linux MIPS(LE) crosscompiler with ucLibc 0.9.29
#
######################################################################
cross-mipsel-router-linux-uclibc929:
	@-mipsel-linux-uclibc-setlib 0.9.29
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lcrypto -lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_LINUX -DMIPSEL -DWITH_LIBCRYPTO -DUCLIBC -DUSE_GPIO -DCS_CONFDIR=${CS_CONFDIR} -static-libgcc -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=mipsel-linux-uclibc-

######################################################################
#
#	Linux MIPS(LE) crosscompiler with ucLibc 0.9.29 (static)
#
######################################################################
cross-mipsel-router-linux-uclibc929-static:
	@-mipsel-linux-uclibc-setlib 0.9.29
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lcrypto -lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_LINUX -DMIPSEL -DWITH_LIBCRYPTO -DUCLIBC -DUSE_GPIO -DCS_CONFDIR=${CS_CONFDIR} -static-libgcc -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=mipsel-linux-uclibc-

######################################################################
#
#	Linux MIPS crosscompiler with ucLibc 0.9.30
#
######################################################################
cross-mips-router-linux-uclibc930:
	@-mips-linux-uclibc-setlib 0.9.30
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lcrypto -lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_LINUX -DMIPS -DWITH_LIBCRYPTO -DUCLIBC -DUSE_GPIO -DCS_CONFDIR=${CS_CONFDIR} -static-libgcc -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=mips-linux-uclibc-

######################################################################
#
#	Linux MIPS crosscompiler with ucLibc 0.9.31
#
######################################################################
cross-mips-router-linux-uclibc931:
	@-mips-linux-uclibc-setlib 0.9.31
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lcrypto -lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_LINUX -DMIPS -DWITH_LIBCRYPTO -DUCLIBC -DUSE_GPIO -DCS_CONFDIR=${CS_CONFDIR} -static-libgcc -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=mips-linux-uclibc-

######################################################################
#
#	Linux MIPS(LE) crosscompiler for La Fonera 2.0
#
######################################################################
cross-mipsel-fonera2:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-Lopenssl-lib -lcrypto -lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-Iopenssl-include -O2 -DOS_LINUX -DWITH_LIBCRYPTO -DMIPSEL -DUCLIBC -DCS_CONFDIR=${CS_CONFDIR} -static-libgcc -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=mips-linux-

######################################################################
#
#	Linux MIPS(LE) crosscompiler with glibc (DM7025)
#
######################################################################
cross-mipsel-tuxbox-linux-glibc:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lcrypto -lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_LINUX -DTUXBOX -DWITH_LIBCRYPTO -DMIPSEL -DCS_CONFDIR='\"/var/tuxbox/config\"' -static-libgcc -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=mipsel-linux-glibc-

cross-mipsel-tuxbox-linux:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lcrypto -lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_LINUX -DTUXBOX -DWITH_LIBCRYPTO -DMIPSEL -DCS_CONFDIR='\"/var/tuxbox/config\"' -static-libgcc -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=mipsel-linux-

######################################################################
#
#	HP/UX 10.20 native
#
######################################################################
hppa1.1-hp-hpux10.20:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_HPUX -DOS_HPUX10 -D_XOPEN_SOURCE_EXTENDED -DCS_CONFDIR=${CS_CONFDIR} -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \

######################################################################
#
#	OSF5.1 native
#
######################################################################
alpha-dec-osf5.1:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP=$(subst cross-,,$@) \
		OS_LIBS="-lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-O2 -DOS_OSF -DOS_OSF5 -DCS_CONFDIR=${CS_CONFDIR} -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		XDS_CFLAGS="-I/usr/include -c" \

######################################################################
#
#	ARM crosscompiler (big-endian)
#
######################################################################
cross-arm-nslu2-linux:
	@-$(MAKE) --no-print-directory \
		-f Maketype TYP="$(subst cross-,,$@)" \
		OS_LIBS="-lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-DOS_LINUX -O2 -DARM -DALIGNMENT -DCS_CONFDIR=${CS_CONFDIR} -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=armv5b-softfloat-linux-

######################################################################
#
#	ARM crosscompiler (big-endian)
#
######################################################################
cross-armBE-unknown-linux:
	-$(MAKE) --no-print-directory \
		-f Maketype TYP="$(subst cross-,,$@)" \
		OS_LIBS="-lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-DOS_LINUX -O2 -DARM -DALIGNMENT -DCS_CONFDIR=${CS_CONFDIR} -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=arm-linux- \
		DS_CC="gcc -mbig-endian" \
		DS_LD="ld -EB"

######################################################################
#
#	ARM crosscompiler (little-endian)
#
######################################################################
cross-armLE-unknown-linux:
	-$(MAKE) --no-print-directory \
		-f Maketype TYP="$(subst cross-,,$@)" \
		OS_LIBS="-lm" \
		OS_PTLI="-lpthread" \
		DS_OPTS="-DOS_LINUX -O2 -DARM -DALIGNMENT -DCS_CONFDIR=${CS_CONFDIR}  -D'CS_SVN_VERSION="\"$(SVN_REV)\""'" \
		DS_CROSS=arm-linux- \
		DS_CC="gcc -mlittle-endian" \
		DS_LD="ld -EL"
