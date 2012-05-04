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
	cross-mipsel-router-linux-uclibc \
	cross-mipsel-tuxbox-linux-glibc \
	cross-mipsel-fonera2 \
	cross-sh4-linux

all:	\
	cross-sparc-sun-solaris2.7 \
	cross-rs6000-ibm-aix4.2 \
	cross-mips-sgi-irix6.5

include $(wildcard toolchains/target_*.make)

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
