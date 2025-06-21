#
#   SEGA SATURN Graphic library make file for GNU

# macro
CC = sh-coff-gcc
RM = rm
CONV = sh-coff-objcopy

# directory
SGLDIR = ../..
SGLIDR = $(SGLDIR)/inc

#GCCDIR = ../../../gccsh
#GCCIDR = $(GCCDIR)/include

# option
CCFLAGS = -O2 -m2 -g -c -I$(SGLIDR)
DFLAGS = 
# source_program

#TARGET   = sl.coff
#TARGET1  = sl.bin
#LDFILE	 = $(COMMONDIR)/$(TARGET:.coff=.lnk)
#MPFILE   = $(TARGET:.coff=.map)
MAKEFILE = makefile

workarea.o : workarea.c

.c.o:
	$(CC) $< $(DFLAGS) $(CCFLAGS) -o $@

clean:
	$(RM) workarea.o
