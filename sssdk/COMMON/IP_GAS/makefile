#
#   SEGA SATURN Graphic library make file for GNU

# macro
CC = sh-$(OBJFMT)-gcc
AS = sh-$(OBJFMT)-as
LD = ld
RM = rm
CONV = sh-$(OBJFMT)-objcopy

# directory
SGLDIR = ../../SGL_302j
SGLIDR = $(SGLDIR)/inc
SGLLDR = $(SGLDIR)/lib_coff

CMNDIR = ../common
OBJECTS = ./objects

# option
CCFLAGS = -O2 -m2 -g -c -I$(SGLIDR)
ASFLAGS =

# -m2 must be specified in LDFLAGS so the linker will search the SH2 lib dirs
# Specify path of libsgl.a by using "-L" option

LDFLAGS = -m2 -Xlinker --format=coff-sh -Xlinker -T$(LDFILE) -nostartfiles -Xlinker -Map \
          -Xlinker $(MPFILE) -nostdlib
          
DFLAGS =
# source_program
include $(OBJECTS)

TARGET   = IP_$(OBJFMT).$(OBJFMT)
TARGET1  = IP_$(OBJFMT).bin
LDFILE	 = IP.lnk
MPFILE   = $(TARGET1:.bin=.map)
MAKEFILE = Makefile

all: $(TARGET) $(TARGET1)

# Use gcc to link so it will automagically find correct libs directory

$(TARGET) : $(OBJS) $(MAKEFILE) $(OBJECTS) $(LDFILE)
	$(CC) $(LDFLAGS) $(OBJS) -o $@

$(TARGET1) : $(OBJS) $(MAKEFILE) $(LDFILE)
	$(CONV) -O binary $(TARGET) $(TARGET1)

# suffix
.SUFFIXES: .asm

%.o: %.src
#.src.o :
	$(AS) $< $(ASFLAGS) $(_ASFLAGS) -o $@

#%.o: %.c
#.c.o :
#	$(CC) $< $(DFLAGS) $(CCFLAGS) -o $@

clean: 
	$(RM) $(CLEAR_OBJS) $(TARGET) $(TARGET1) $(MPFILE)

