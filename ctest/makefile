## MOXIE TOOL CHAIN
MOXIEPATH=/opt/moxielogic
AS=$(MOXIEPATH)/bin/moxie-elf-as
LD=$(MOXIEPATH)/bin/moxie-elf-ld
CC=$(MOXIEPATH)/bin/moxie-elf-gcc
OBJDUMP=$(MOXIEPATH)/bin/moxie-elf-objdump
OBJCOPY=$(MOXIEPATH)/bin/moxie-elf-objcopy

## TOOL OPTIONS
ENDIANESS=-EB
ASOPTS=$(ENDIANESS)
LDOPTS=$(ENDIANESS)
CCOPTS=-Wa,$(ENDIANESS) -std=c99 -save-temps=obj

## Output directory
OUT = ./build

## List of all object files
OBJ_FILES = \
	$(OUT)/startup.o \
	$(OUT)/main.o \
	$(OUT)/threading.o

## Link Step
$(OUT)/ctest.bin: $(OBJ_FILES)
	$(LD) $(LDOPTS) $(OBJ_FILES) $(MOXIEPATH)/moxie-elf/lib/libc.a -Map $(OUT)/ctest.map -o $(OUT)/ctest.elf -Tmoxie-elf-embedded.ld

$(OUT)/%.o: %.c $(OUT)
	$(CC) $(CCOPTS) -c $< -o $@

$(OUT)/%.o: %.s $(OUT)
	$(AS) $(ASOPTS) -o $@ $< 

$(OUT):
	mkdir -p $(OUT)

clean:
	rm -rf $(OUT)
