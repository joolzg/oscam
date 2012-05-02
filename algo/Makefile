SHELL		= /bin/sh

GENERAL		= Makefile minilzo.h

LIBDIR		= ../lib
LIBFILE1	= $(LIBDIR)/libminilzo-$(TYP).a

OBJECTS1	= $(LIBFILE1)(minilzo.o)

all:		$(LIBFILE1)

$(LIBFILE1):	$(OBJECTS1)
	$(SAY) "RANLIB	$@"
	-$(Q)$(RANLIB) $@

$(OBJECTS1):	$(GENERAL)

.c.a:
	$(SAY) "CC	algo/$<"
	$(Q)$(CC) $(CFLAGS) $<
	$(Q)$(AR) $(ARFLAGS) $@ $*.o
	-@rm -f $*.o

.SUFFIXES:	.o .c .a
