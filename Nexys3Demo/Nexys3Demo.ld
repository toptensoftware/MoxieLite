OUTPUT_FORMAT("elf32-bigmoxie", "elf32-bigmoxie", "elf32-littlemoxie")
OUTPUT_ARCH(moxie)
ENTRY(_start)

MEMORY 
{
	ROM (rx)       : ORIGIN = 0x00100000, LENGTH = 512k 
	RAM (rwx)      : ORIGIN = 0x00200000, LENGTH = 4k 
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
        *(.ctors)
        *(.dtors)
        *(.eh_frame)
        *(.jcr)
        *(.tm_clone_table)
	    . = ALIGN(0x4); 
    } >ROM

    .ramtop : 
    {
        __ram_top = . + LENGTH(RAM);
        _stack = __ram_top;
    } >RAM

    .romdata : 
    { 
	    __data_load__ = LOADADDR (.romdata); 
        __data_start__ = .; 
        *(.data .data.* .gnu.linkonce.d.*) 
        . = ALIGN (4); 
	    __data_end__ = .; 
	} >RAM AT>ROM 


    .bss : 
    { 
        __bss_start__ = . ; 
        *(.bss .bss.* .gnu.linkonce.b.*) 
        *(COMMON)
        . = ALIGN (4); 
        __bss_end__ = .; 
    } >RAM

}