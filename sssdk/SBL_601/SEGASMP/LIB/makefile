OBJS = STRT1_G.o main.o other.o

TARGET = mygame

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(OBJS) -T your_linker_script.ld -o $(TARGET).elf
