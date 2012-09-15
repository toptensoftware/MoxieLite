	.text
	.p2align	1
	.global	_start

_start:
	ldi.l	$sp,__ram_top

	# Copy data section from ROM to RAM
	ldi.l	$r0,__data_start
	ldi.l	$r1,__data_load
	ldi.l	$r2,__data_end
	sub.l	$r2,$r0
	jsra	memcpy

	# Zero BSS section
	ldi.l	$r0,__bss_start
	xor		$r1,$r1
	ldi.l	$r2,__bss_end
	sub.l	$r2,$r0
	jsra	memset

	# Jump to main
	jsra	main
	brk

	# This section defines the PCU's "ports" which used to be 
	# actual I/O ports with the Z80 implementation but are now
	# memory mapped starting at 0x80000000
	.section .ports

	.global port_leds_linear		
	.global port_leds_7seg			
	.global port_reserved		
	.global port_sd_op_cmd		
	.global port_sd_status			
	.global port_sd_block_number
	.global port_sd_dma_bank_select
	.global port_console_mode		
	.global port_cursor_position	
	.global port_keyboard_state	
	.global port_keyboard_message	

	port_leds_linear:		.word	0 	# 0x00
	port_leds_7seg:			.word	0 	# 0x02
	port_reserved:			.word	0 	# 0x04
	port_sd_op_cmd:			.word 	0	# 0x06
	port_sd_status:			.word	0	# 0x08
	port_sd_block_number:	.word 	0x99	# 0x0A
							.word	0xAA
	port_sd_dma_bank_select:.word 	0 	# 0x0E
	port_console_mode:		.word 	0	# 0x10
	port_cursor_position:	.word	0	# 0x12
	port_keyboard_state:	.word	0	# 0x14
	port_keyboard_message:	.word	0	# 0x16

