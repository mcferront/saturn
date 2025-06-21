#
# Makefile for creating the IP.BIN using the GNU Compiler and Assembler
#
# slightly modified

CC = sh-$(OBJFMT)-gcc
AS = gasm.bat
CONV = sh-$(OBJFMT)-objcopy
RM = rm
#LD = ld
#GCC     = o:\apps\gnu

#
# General Compiler, Assembler and Linker flags
#
#CFLAGS  = -g -O0 -Wall -DMODEL_S -I$(GCC)/include
CFLAGS  = -g -O0 -Wall -DMODEL_S
ASFLAGS =
#LDFLAGS = -o $(TARGET).s -Map $(TARGET).map -T $(LOCATE_FILE)
LDFLAGS = -m2 -Xlinker -T$(LOCATE_FILE) -nostartfiles -Xlinker -Map \
          -Xlinker ip.map -nostdlib

#
# Where to find the security code and area code object files
#
SGLLIB = ../lib

#
# The name of the security code object file
#
SECOBJ = $(SGLLIB)/sys_sec.o

#
# Area symbols.
#
# Must be modified in conjunction with changes to Area symbols in the
# build file sys_id.src.
#
# The name of the area code object files to link in.
#
# Delete these as necessary.  For instance if your game has to run in 
# Japan, USA and the UK, edit the line so it reads:
# AREAOBJ = $(SGLLIB)/sys_arej.o $(SGLLIB)sys_areu.o $(SGLLIB)sys_aree.o
#
# AREAOBJ = $(SGLLIB)/sys_arej.o $(SGLLIB)/sys_aret.o $(SGLLIB)/sys_areu.o \
#	   $(SGLLIB)/sys_aree.o

AREAOBJ = $(SGLLIB)/sys_arej.o

#
# The place to find the init code
#
INITOBJ = $(SGLLIB)/sys_init.o

#
# Macros defining Linker script files and a Makefile include file
#
LOCATE_FILE = smpsys.lnk
CONFIG_FILE = smpsys.cfg

#
# Include some more macros
#
include $(CONFIG_FILE)

.SUFFIXES:
.SUFFIXES: .sre .o .src .c

all: ip.bin

#
# Rule for linking various objects and for making the ip.bin
#
ip.bin:    $(OBJS)
	$(CC) $(LDFLAGS) sys_id.o $(SECOBJ) $(AREAOBJ) $(INITOBJ) smpsys.o -o ip.coff
	$(CONV) -O binary ip.coff ip.bin


clean: 
	$(RM) $(OBJS) ip.map ip.coff ip.bin


#
# Rule for making 'C' code
#
%.o: %.c
	$(CC) -c $(CFLAGS) -o $@ $<

#
# Rule for making assembler code
#
%.o: %.src
	$(AS) $< $(ASFLAGS) -o $@
