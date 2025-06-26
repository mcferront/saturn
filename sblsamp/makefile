PROJECT=sblsamp
OBJFMT=coff
OUTPUTDIR=build

# List of source directories
SRC_DIRS = . $(SSSDK)/SBL_601/SEGASMP\LIB

# Find all .c files in all source directories
SRCS = $(foreach dir, $(SRC_DIRS), $(wildcard $(dir)/*.c))

# SYSOBJS = $(SGLLDR)/sglarea.o
OBJS = $(SRCS:.c=.o)

#_LDFLAGS = $(SSSDK)/SBL_601/SEGALIB/LIB/SEGA_SGL.A
# 	LIBS = -lSEGA_SGL.A

LIBS=	$(SEGALIB)/lib/sega_sgl.a\
		$(SEGALIB)/lib/sega_per.a\
		$(SEGALIB)/lib/sega_sat.a\
		$(SEGALIB)/lib/sega_cdc.a\
		$(SEGALIB)/lib/sega_adp.a

include $(SSSDK)/COMMON/mf_SBL
#include MAKECOFF.MAK


