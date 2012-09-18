## MOXIE TOOL CHAIN
MOXIEPATH=../ToolChain/bin
AS=$(MOXIEPATH)/moxie-elf-as.exe
LD=$(MOXIEPATH)/moxie-elf-ld.exe
CC=$(MOXIEPATH)/moxie-elf-gcc.exe
OBJDUMP=$(MOXIEPATH)/moxie-elf-objdump.exe
OBJCOPY=$(MOXIEPATH)/moxie-elf-objcopy.exe

## TOOL OPTIONS
ASOPTS=-EL
LDOPTS=-EL
CCOPTS=-Wa,-EL -std=c99 -save-temps=obj

## Output directory
OUT = ./build

## List of all object files
OBJ_FILES = \
	$(OUT)/startup.o \
	$(OUT)/main.o \
	$(OUT)/threading.o

## Link Step
$(OUT)/ctest.bin: $(OBJ_FILES)
	$(LD) $(LDOPTS) $(OBJ_FILES) ../ToolChain/moxie-elf/lib/el/libc.a -Map $(OUT)/ctest.map -o $(OUT)/ctest.elf -Tmoxie-elf-embedded.ld
	$(OBJCOPY) --remove-section .data -O binary $(OUT)/ctest.elf $@
	$(OBJDUMP) -s $(OUT)/ctest.elf > $(OUT)/ctest.elf.data
	$(OBJDUMP) -d $(OUT)/ctest.elf > $(OUT)/ctest.elf.dis


$(OUT)/startup.o: startup.s

$(OUT)/main.o: main.c threading.h

$(OUT)/main.o: threading.c threading.h


$(OUT)/%.o: %.s
	$(AS) $(ASOPTS) -o $@ $< 
	$(OBJDUMP) -d $@ > $@.dis

$(OUT)/%.o: %.c
	$(CC) $(CCOPTS) -c -o $@ $< 
	$(OBJDUMP) -d $@ > $@.dis
	$(OBJDUMP) -s $@ > $@.data

clean:
	rm $(OUT)/*
