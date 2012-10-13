MOXIEPATH=..\..\moxie\ToolChain\bin
AS=$(MOXIEPATH)\moxie-elf-as.exe -EL
LD=$(MOXIEPATH)\moxie-elf-ld.exe -EL
OBJCOPY=$(MOXIEPATH)\moxie-elf-objcopy.exe


## SETTINGS FOR SYNTHESIS
DEVICE			= xc6slx16-2-csg324
PROJNAME		= Nexys3Demo
INTDIR			= .\mkbuild
HDL_FILES		= \
	Nexys3Demo.vhd \
	FlashMemoryController.vhd \
	ipcore_dir\ClockCore.vhd \
	ipcore_dir\ram4k16bit.vhd \
	$(MOXIELITE_FILES)

MOXIELITE_FILES = \
	..\cpu\moxielite_package.vhd \
	..\cpu\moxielite.vhd \
	..\cpu\moxielite_alu.vhd \
	..\cpu\moxielite_alu2.vhd \
 	..\cpu\moxielite_decode.vhd \
	..\cpu\moxielite_lshift.vhd \
	..\cpu\moxielite_rshift.vhd \
	..\cpu\moxielite_multiplier.vhd \
	..\cpu\moxielite_divider.vhd 

all: $(INTDIR)\$(PROJNAME).bit Nexys3Demo.bin


Nexys3Demo.bin : Nexys3Demo.s
	$(AS) Nexys3Demo.s -o Nexys3Demo.o
	$(LD) Nexys3Demo.o -o Nexys3Demo.elf -TNexys3Demo.ld
	$(OBJCOPY) -O binary Nexys3Demo.elf Nexys3Demo.bin



!INCLUDE makefile_xilinx


