#
#   SEGA SATURN Graphic library make file for GNU

# macro
CC = gcc
RM = deltree
CONV = objcopy

# directory
SGLDIR = ../..
SGLIDR = $(SGLDIR)/inc

GCCDIR = ../../../gccsh
GCCIDR = $(GCCDIR)/include

# option
CCFLAGS = -O2 -m2 -g -c -I$(GCCIDR) -I$(SGLIDR)
DFLAGS = 
# source_program

TARGET   = sl.coff
TARGET1  = sl.bin
LDFILE	 = $(COMMONDIR)/$(TARGET:.coff=.lnk)
MPFILE   = $(TARGET:.coff=.map)
MAKEFILE = Makefile

cinit.o : cinit.c

.c.o:
	$(CC) $< $(DFLAGS) $(CCFLAGS) -o $@

clean:
	$(RM) cinit.o
