## MOXIE TOOL CHAIN
PATH=c:\cygwin\bin;..\ToolChain\bin;$(PATH)

AS=moxie-elf-as.exe
LD=moxie-elf-ld.exe
OBJDUMP=moxie-elf-objdump.exe
OBJCOPY=moxie-elf-objcopy.exe

ASOPTS=-EL
LDOPTS=

## SETTINGS FOR SYNTHESIS
DEVICE			= xc6slx16-2-csg324
PROJNAME		= moxielite
INTDIR			= .\mkbuild
HDL_FILES		= \
	$(MOXIELITE_FILES)

MOXIELITE_FILES = \
	moxielite.vhd \
	moxielite_package.vhd \
 	moxielite_decode.vhd \
	moxielite_alu.vhd \
	moxielite_alu2.vhd \
	moxielite_lshift.vhd \
	moxielite_rshift.vhd \
	moxielite_multiplier.vhd \
	moxielite_divider.vhd 

## SETTINGS FOR SIMULATION
SIM_HDL_FILES   = TestBench.vhd sim_ram.vhd $(MOXIELITE_FILES)
SIM_TOP         = TestBench
SIM_TIME		= 000 ns
SIM_OTHER_DEPS	= rom.hex

GHDL_OPTS=-fexplicit --ieee=synopsys


all: $(INTDIR)\$(PROJNAME).bit

buildsim: $(SIM_TOP)_sim.exe

ghdl: work-obj93.cf rom.hex

ghdl-run: ghdl
	ghdl -r $(GHDL_OPTS) TestBench

work-obj93.cf: TestBench.vhd sim_ram.vhd $(MOXIELITE_FILES)
	ghdl -i $(GHDL_OPTS) TestBench.vhd sim_ram.vhd $(MOXIELITE_FILES) 
	ghdl -m $(GHDL_OPTS) TestBench

rom.hex : rom.s
	$(AS) $(ASOPTS) rom.s -o rom.o
	$(LD) $(LDOPTS) rom.o -o rom.elf -Tmoxie-elf-common.ld
	$(OBJDUMP) -d rom.o > rom.o.dis
	$(OBJCOPY) -O binary rom.elf rom.bin
	python bin2hex.py rom.bin rom.hex 0 4096

	# $(OBJDUMP) -d rom.elf > rom.elf.dis

TestBench.vhd : rom.hex

!INCLUDE makefile_xilinx


