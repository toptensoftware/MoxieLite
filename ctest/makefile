## MOXIE TOOL CHAIN
MOXIEPATH=/opt/moxielogic
CC=$(MOXIEPATH)/bin/moxie-elf-gcc
OBJDUMP=$(MOXIEPATH)/bin/moxie-elf-objdump
OBJCOPY=$(MOXIEPATH)/bin/moxie-elf-objcopy

## TOOL OPTIONS
CCOPTS=-mel -std=c99 -save-temps=obj

## Output directory
OUT = ./build

## List of all object files
OBJ_FILES = \
	$(OUT)/startup.o \
	$(OUT)/main.o \
	$(OUT)/threading.o

## Link Step
$(OUT)/ctest.bin: $(OBJ_FILES)
	$(CC) $(OBJ_FILES) -nostartfiles -Wl,-Map,$(OUT)/ctest.map -o $(OUT)/ctest.bin -Tmoxie-elf-embedded.ld

$(OUT)/%.o: %.c $(OUT)
	$(CC) $(CCOPTS) -c $< -o $@

$(OUT)/%.o: %.s $(OUT)
	$(CC) $(CCOPTS) -c -o $@ $< 

$(OUT):
	mkdir -p $(OUT)

clean:
	rm -rf $(OUT)
