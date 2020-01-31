## MOXIE TOOL CHAIN
MOXIEPATH=/opt/moxielogic
AS=$(MOXIEPATH)/bin/moxiebox-as
LD=$(MOXIEPATH)/bin/moxiebox-ld
CC=$(MOXIEPATH)/bin/moxiebox-gcc
OBJDUMP=$(MOXIEPATH)/bin/moxiebox-objdump
OBJCOPY=$(MOXIEPATH)/bin/moxiebox-objcopy

## TOOL OPTIONS
ENDIANESS=-EL
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
	$(LD) $(LDOPTS) $(OBJ_FILES) $(MOXIEPATH)/moxiebox/lib/libc.a -Map $(OUT)/ctest.map -o $(OUT)/ctest.elf -Tmoxie-elf-embedded.ld

$(OUT)/%.o: %.c $(OUT)
	$(CC) $(CCOPTS) -c $< -o $@

$(OUT)/%.o: %.s $(OUT)
	$(AS) $(ASOPTS) -o $@ $< 

$(OUT):
	mkdir -p $(OUT)

clean:
	rm -rf $(OUT)
