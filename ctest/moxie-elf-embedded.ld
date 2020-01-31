OUTPUT_FORMAT("elf32-littlemoxie")
OUTPUT_ARCH(moxie)
ENTRY(_start)

MEMORY 
{
	ROM (rx)       : ORIGIN = 0x00100000, LENGTH = 512k 
	RAM (rwx)      : ORIGIN = 0x00200000, LENGTH = 4k 
	VRAM (rwx)     : ORIGIN = 0x00300000, LENGTH = 2k 
	DMARAM (rwx)   : ORIGIN = 0x00400000, LENGTH = 2k 
    PORTS (rwx)    : ORIGIN = 0x80000000, LENGTH = 1k
} 

SECTIONS
{
 	.startup : 
 	{ 
        *startup.o (.text)
	    . = ALIGN(0x4); 
    } >ROM 

    .text :
    {
    	*(.text) 
	    . = ALIGN(0x4); 
    } >ROM

    .rodata :
    {
    	*(.rodata)
	    . = ALIGN(0x4); 
    } >ROM

    .ramtop : 
    {
        __ram_top = . + LENGTH(RAM);
    } >RAM

    .romdata : 
    { 
	    __data_load = LOADADDR (.romdata); 
        __data_start = .; 
        *(.data .data.* .gnu.linkonce.d.*) 
        . = ALIGN (4); 
	    __data_end = .; 
	} >RAM AT>ROM 


    .bss : 
    { 
        __bss_start = . ; 
        *(.bss .bss.* .gnu.linkonce.b.*) 
        *(COMMON)
        . = ALIGN (4); 
        __bss_end = .; 
    } >RAM

    .vram : 
    {
        vram_buffer = .;
        vram_buffer_end = . + LENGTH(VRAM);
    } > VRAM

    .dmaram :
    {
        vram_buffer = .;
        vram_buffer_end = . + LENGTH(DMARAM);
    } > DMARAM

    .ports : 
    {
        *(.ports)    
    } > PORTS
}
