OBJFILE = IP.coff
PREFIX = IP_coff

MAPFILE = $(PREFIX).map
LINKFILE = IP_coff.lnk
BINFILE = $(PREFIX).bin

all-before:

all-after: $(BINFILE)

$(BINFILE): $(OBJFILE)
	sh-coff-objcopy -O binary $(OBJFILE) $(BINFILE)
