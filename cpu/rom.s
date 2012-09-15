	.text
	.p2align	1
	.global	_start

	.equ BIG_ENDIAN,0

_start:

	############ Misc Tests ##############

nop_test:
	nop
	nop
	nop
nop_test_pass:


	############ Equality tests ##############

	# Load some constants
	ldi.l	$r0,1
	ldi.l	$r1,2
 
	# BEQ true test
beq_1_test:
	cmp		$r0,$r0
	beq		beq_1_pass
	bad
beq_1_pass:

	# BEQ false test
beq_2_test:
	cmp		$r0,$r1
	beq		beq_2_fail
	jmpa	beq_2_pass
beq_2_fail:
	bad
beq_2_pass:

	# BNE true test
bne_1_test:
	cmp		$r0,$r1
	bne		bne_1_pass
	bad
bne_1_pass:

	# BNE false test
bne_2_test:
	cmp		$r0,$r0
	bne		bne_2_fail
	jmpa	bne_2_pass
bne_2_fail:
	bad
bne_2_pass:


	############ Unsigned GT/LT ##############

	ldi.l	$r0,0xA0000100
	ldi.l	$r1,0xA0000200

	# BGTU true test
bgtu_1_test:
	cmp		$r1,$r0
	bgtu 	bgtu_1_pass
	bad
bgtu_1_pass:

	# BGTU false test
bgtu_2_test:
	cmp		$r0,$r1
	bgtu	bgtu_2_fail
	jmpa	bgtu_2_pass
bgtu_2_fail:
	bad
bgtu_2_pass:

	# BGTU false (equal) test
bgtu_3_test:
	cmp		$r0,$r0
	bgtu	bgtu_3_fail
	jmpa	bgtu_3_pass
bgtu_3_fail:
	bad
bgtu_3_pass:

	# BLTU true test
bltu_1_test:
	cmp		$r0,$r1
	bltu 	bltu_1_pass
	bad
bltu_1_pass:

	# BLTU false test
bltu_2_test:
	cmp		$r1,$r0
	bltu	bltu_2_fail
	jmpa	bltu_2_pass
bltu_2_fail:
	bad
bltu_2_pass:

	# BLTU false (equal) test
bltu_3_test:
	cmp		$r0,$r0
	bltu	bltu_3_fail
	jmpa	bltu_3_pass
bltu_3_fail:
	bad
bltu_3_pass:



	# BGEU true test
bgeu_1_test:
	cmp		$r1,$r0
	bgeu 	bgeu_1_pass
	bad
bgeu_1_pass:

	# BGEU false test
bgeu_2_test:
	cmp		$r0,$r1
	bgeu	bgeu_2_fail
	jmpa	bgeu_2_pass
bgeu_2_fail:
	bad
bgeu_2_pass:

	# BGEU false (equal) test
bgeu_3_test:
	cmp		$r0,$r0
	bgeu	bgeu_3_pass
	bad
bgeu_3_pass:

	# BLEU true test
bleu_1_test:
	cmp		$r0,$r1
	bleu 	bleu_1_pass
	bad
bleu_1_pass:

	# BLEU false test
bleu_2_test:
	cmp		$r1,$r0
	bleu	bleu_2_fail
	jmpa	bleu_2_pass
bleu_2_fail:
	bad
bleu_2_pass:

	# BLEU false (equal) test
bleu_3_test:
	cmp		$r0,$r0
	bleu	bleu_3_pass
	bad
bleu_3_pass:


	############ Signed GT/LT ##############

	ldi.l	$r0,-100
	ldi.l	$r1,100

	# BGT true test
bgt_1_test:
	cmp		$r1,$r0
	bgt 	bgt_1_pass
	bad
bgt_1_pass:

	# BGT false test
bgt_2_test:
	cmp		$r0,$r1
	bgt	bgt_2_fail
	jmpa	bgt_2_pass
bgt_2_fail:
	bad
bgt_2_pass:

	# BGT false (equal) test
bgt_3_test:
	cmp		$r0,$r0
	bgt	bgt_3_fail
	jmpa	bgt_3_pass
bgt_3_fail:
	bad
bgt_3_pass:

	# BLT true test
blt_1_test:
	cmp		$r0,$r1
	blt 	blt_1_pass
	bad
blt_1_pass:

	# BLT false test
blt_2_test:
	cmp		$r1,$r0
	blt	blt_2_fail
	jmpa	blt_2_pass
blt_2_fail:
	bad
blt_2_pass:

	# BLT false (equal) test
blt_3_test:
	cmp		$r0,$r0
	blt		blt_3_fail
	jmpa	blt_3_pass
blt_3_fail:
	bad
blt_3_pass:

	# BGE true test
bge_1_test:
	cmp		$r1,$r0
	bge 	bge_1_pass
	bad
bge_1_pass:

	# BGE false test
bge_2_test:
	cmp		$r0,$r1
	bge		bge_2_fail
	jmpa	bge_2_pass
bge_2_fail:
	bad
bge_2_pass:

	# BGE false (equal) test
bge_3_test:
	cmp		$r0,$r0
	bge		bge_3_pass
	bad
bge_3_pass:

	# BLE true test
ble_1_test:
	cmp		$r0,$r1
	ble 	ble_1_pass
	bad
ble_1_pass:

	# BLE false test
ble_2_test:
	cmp		$r1,$r0
	ble		ble_2_fail
	jmpa	ble_2_pass
ble_2_fail:
	bad
ble_2_pass:

	# BLE false (equal) test
ble_3_test:
	cmp		$r0,$r0
	ble		ble_3_pass
	bad
ble_3_pass:


	############ Primary ALU Tests ##############

mov_test:
	ldi.l	$r0,0		# A
	ldi.l	$r1,200		# B
	ldi.l	$r2,200		# R
	mov 	$r0,$r1
	cmp		$r0,$r2
	beq		mov_test_pass
	bad
mov_test_pass:

add_test:
	ldi.l	$r0,100		# A
	ldi.l	$r1,200		# B
	ldi.l	$r2,300		# R
	add.l 	$r0,$r1
	cmp		$r0,$r2
	beq		add_test_pass
	bad
add_test_pass:

sub_test:
	ldi.l	$r0,300		# A
	ldi.l	$r1,100		# B
	ldi.l	$r2,200		# R
	sub.l 	$r0,$r1
	cmp		$r0,$r2
	beq		sub_test_pass
	bad
sub_test_pass:

and_test:
	ldi.l	$r0,0x12345678		# A
	ldi.l	$r1,0xF0F0F0F0		# B
	ldi.l	$r2,0x10305070		# R
	and 	$r0,$r1
	cmp		$r0,$r2
	beq		and_test_pass
	bad
and_test_pass:

or_test:
	ldi.l	$r0,0x12340101		# A
	ldi.l	$r1,0xFFF01010		# B
	ldi.l	$r2,0xFFF41111		# R
	or	 	$r0,$r1
	cmp		$r0,$r2
	beq		or_test_pass
	bad
or_test_pass:

xor_test:
	ldi.l	$r0,0x12340101		# A
	ldi.l	$r1,0xFFF01010		# B
	ldi.l	$r2,0xEDC41111		# R
	xor	 	$r0,$r1
	cmp		$r0,$r2
	beq		xor_test_pass
	bad
xor_test_pass:


not_test:
	ldi.l	$r0,0				# A
	ldi.l	$r1,0x12345678		# B
	ldi.l	$r2,0xEDCBA987		# R
	not	 	$r0,$r1
	cmp		$r0,$r2
	beq		not_test_pass
	bad
not_test_pass:

neg_1_test:
	ldi.l	$r0,0				# A
	ldi.l	$r1,100				# B
	ldi.l	$r2,-100			# R
	neg	 	$r0,$r1
	cmp		$r0,$r2
	beq		neg_1_test_pass
	bad
neg_1_test_pass:

neg_2_test:
	ldi.l	$r0,0				# A
	ldi.l	$r1,-100			# B
	ldi.l	$r2,100				# R
	neg	 	$r0,$r1
	cmp		$r0,$r2
	beq		neg_2_test_pass
	bad
neg_2_test_pass:

inc_test:
	ldi.l	$r0,100
	ldi.l	$r2,350
	inc 	$r0,250
	cmp		$r0,$r2
	beq		inc_test_pass
	bad
inc_test_pass:

dec_test:
	ldi.l	$r0,400
	ldi.l	$r2,150
	dec 	$r0,250
	cmp		$r0,$r2
	beq		dec_test_pass
	bad
dec_test_pass:

lshr_test:
	ldi.l	$r0,0x00AAAA00
	ldi.l	$r1,5
	ldi.l	$r2,0x00055550
	lshr 	$r0,$r1
	cmp		$r0,$r2
	beq		lshr_test_pass
	bad
lshr_test_pass:

ashl_test:
	ldi.l	$r0,0x00555500
	ldi.l	$r1,5
	ldi.l	$r2,0x0AAAA000
	ashl 	$r0,$r1
	cmp		$r0,$r2
	beq		ashl_test_pass
	bad
ashl_test_pass:

ashr_1_test:
	ldi.l	$r0,0x00AAAA00
	ldi.l	$r1,5
	ldi.l	$r2,0x00055550
	ashr 	$r0,$r1
	cmp		$r0,$r2
	beq		ashr_1_test_pass
	bad
ashr_1_test_pass:

ashr_2_test:
	ldi.l	$r0,0x80AAAA00
	ldi.l	$r1,5
	ldi.l	$r2,0xFC055550
	ashr 	$r0,$r1
	cmp		$r0,$r2
	beq		ashr_2_test_pass
	bad
ashr_2_test_pass:

	############ Secondary ALU Tests ##############

mul_1_test:
	ldi.l	$r0,100
	ldi.l	$r1,200
	ldi.l	$r2,20000
	mul.l 	$r0,$r1
	cmp		$r0,$r2
	beq		mul_1_test_pass
	bad
mul_1_test_pass:

mul_2_test:
	ldi.l	$r0,100
	ldi.l	$r1,-200
	ldi.l	$r2,-20000
	mul.l 	$r0,$r1
	cmp		$r0,$r2
	beq		mul_2_test_pass
	bad
mul_2_test_pass:

mul_3_test:
	ldi.l	$r0,-100
	ldi.l	$r1,200
	ldi.l	$r2,-20000
	mul.l 	$r0,$r1
	cmp		$r0,$r2
	beq		mul_3_test_pass
	bad
mul_3_test_pass:

mul_4_test:
	ldi.l	$r0,-100
	ldi.l	$r1,-200
	ldi.l	$r2,20000
	mul.l 	$r0,$r1
	cmp		$r0,$r2
	beq		mul_4_test_pass
	bad
mul_4_test_pass:



div_1_test:
	ldi.l	$r0,20000
	ldi.l	$r1,200
	ldi.l	$r2,100
	div.l 	$r0,$r1
	cmp		$r0,$r2
	beq		div_1_test_pass
	bad
div_1_test_pass:

div_2_test:
	ldi.l	$r0,20000
	ldi.l	$r1,-200
	ldi.l	$r2,-100
	div.l 	$r0,$r1
	cmp		$r0,$r2
	beq		div_2_test_pass
	bad
div_2_test_pass:

div_3_test:
	ldi.l	$r0,-20000
	ldi.l	$r1,200
	ldi.l	$r2,-100
	div.l 	$r0,$r1
	cmp		$r0,$r2
	beq		div_3_test_pass
	bad
div_3_test_pass:

div_4_test:
	ldi.l	$r0,-20000
	ldi.l	$r1,-200
	ldi.l	$r2,100
	div.l 	$r0,$r1
	cmp		$r0,$r2
	beq		div_4_test_pass
	bad
div_4_test_pass:

udiv_test:
	ldi.l	$r0,3000000000
	ldi.l	$r1,150000000
	ldi.l	$r2,20
	udiv.l 	$r0,$r1
	cmp		$r0,$r2
	beq		udiv_test_pass
	bad
udiv_test_pass:


mod_1_test:
	ldi.l	$r0,20010
	ldi.l	$r1,200
	ldi.l	$r2,10
	mod.l 	$r0,$r1
	cmp		$r0,$r2
	beq		mod_1_test_pass
	bad
mod_1_test_pass:

mod_2_test:
	ldi.l	$r0,20010
	ldi.l	$r1,-200
	ldi.l	$r2,10
	mod.l 	$r0,$r1
	cmp		$r0,$r2
	beq		mod_2_test_pass
	bad
mod_2_test_pass:

mod_3_test:
	ldi.l	$r0,-20010
	ldi.l	$r1,200
	ldi.l	$r2,-10
	mod.l 	$r0,$r1
	cmp		$r0,$r2
	beq		mod_3_test_pass
	bad
mod_3_test_pass:

mod_4_test:
	ldi.l	$r0,-20010
	ldi.l	$r1,-200
	ldi.l	$r2,-10
	mod.l 	$r0,$r1
	cmp		$r0,$r2
	beq		mod_4_test_pass
	bad
mod_4_test_pass:

umod_test:
	ldi.l	$r0,3000000100
	ldi.l	$r1,150000000
	ldi.l	$r2,100
	umod.l 	$r0,$r1
	cmp		$r0,$r2
	beq		umod_test_pass
	bad
umod_test_pass:

	############ LDA/STA Tests ##############

	## Aligned Write Long Test ##

	# Write long
mem_1_test:
	ldi.l		$r1,0x12345678
	sta.l		(0x2000), $r1

	# Read long
	lda.l		$r2,(0x2000)
	cmp			$r1,$r2
	beq			mem_1_long_ok
	bad
mem_1_long_ok:

	# Read short 0
	xor			$r2,$r2
	lda.s		$r2,(0x2000)
.if BIG_ENDIAN
	ldi.l		$r3,0x1234
.else
	ldi.l		$r3,0x5678
.endif
	cmp			$r2,$r3
	beq			mem_1_short_0_ok
	bad
mem_1_short_0_ok:

	# Read short 1
	xor			$r2,$r2
	lda.s		$r2,(0x2002)
.if BIG_ENDIAN
	ldi.l		$r3,0x5678
.else
	ldi.l		$r3,0x1234
.endif
	cmp			$r2,$r3
	beq			mem_1_short_1_ok
	bad
mem_1_short_1_ok:

	# Read byte 0 
	lda.b		$r2,(0x2000)
.if BIG_ENDIAN
	ldi.l		$r3,0x12
.else
	ldi.l		$r3,0x78
.endif
	cmp			$r2,$r3
	beq			mem_1_byte_0_ok
	bad
mem_1_byte_0_ok:

	# Read byte 1
	lda.b		$r2,(0x2001)
.if BIG_ENDIAN
	ldi.l		$r3,0x34
.else
	ldi.l		$r3,0x56
.endif
	cmp			$r2,$r3
	beq			mem_1_byte_1_ok
	bad
mem_1_byte_1_ok:

	# Read byte 2
	lda.b		$r2,(0x2002)
.if BIG_ENDIAN
	ldi.l		$r3,0x56
.else
	ldi.l		$r3,0x34
.endif
	cmp			$r2,$r3
	beq			mem_1_byte_2_ok
	bad
mem_1_byte_2_ok:

	# Read byte 3
	lda.b		$r2,(0x2003)
.if BIG_ENDIAN
	ldi.l		$r3,0x78
.else
	ldi.l		$r3,0x12
.endif
	cmp			$r2,$r3
	beq			mem_1_byte_3_ok
	bad
mem_1_byte_3_ok:


	## Unaligned Write Long Test ##
	
	# Write long
mem_2_test:
	ldi.l		$r1,0x12345678
	sta.l		(0x2001), $r1

	# Read long
	lda.l		$r2,(0x2001)
	cmp			$r1,$r2
	beq			mem_2_long_ok
	bad
mem_2_long_ok:

	# Read short 0
	xor			$r2,$r2
	lda.s		$r2,(0x2001)
.if BIG_ENDIAN
	ldi.l		$r3,0x1234
.else
	ldi.l		$r3,0x5678
.endif
	cmp			$r2,$r3
	beq			mem_2_short_0_ok
	bad
mem_2_short_0_ok:

	# Read short 1
	xor			$r2,$r2
	lda.s		$r2,(0x2003)
.if BIG_ENDIAN
	ldi.l		$r3,0x5678
.else
	ldi.l		$r3,0x1234
.endif
	cmp			$r2,$r3
	beq			mem_2_short_1_ok
	bad
mem_2_short_1_ok:

	# Read byte 0 
	lda.b		$r2,(0x2001)
.if BIG_ENDIAN
	ldi.l		$r3,0x12
.else
	ldi.l		$r3,0x78
.endif
	cmp			$r2,$r3
	beq			mem_2_byte_0_ok
	bad
mem_2_byte_0_ok:

	# Read byte 1
	lda.b		$r2,(0x2002)
.if BIG_ENDIAN
	ldi.l		$r3,0x34
.else
	ldi.l		$r3,0x56
.endif
	cmp			$r2,$r3
	beq			mem_2_byte_1_ok
	bad
mem_2_byte_1_ok:

	# Read byte 2
	lda.b		$r2,(0x2003)
.if BIG_ENDIAN
	ldi.l		$r3,0x56
.else
	ldi.l		$r3,0x34
.endif
	cmp			$r2,$r3
	beq			mem_2_byte_2_ok
	bad
mem_2_byte_2_ok:

	# Read byte 3
	lda.b		$r2,(0x2004)
.if BIG_ENDIAN
	ldi.l		$r3,0x78
.else
	ldi.l		$r3,0x12
.endif
	cmp			$r2,$r3
	beq			mem_2_byte_3_ok
	bad
mem_2_byte_3_ok:


	## Aligned Write Short Test ##

	# Write Short
mem_3_test:
	ldi.l		$r1,0x1234
	sta.s		(0x2000), $r1

	# Read short
	lda.s		$r2,(0x2000)
	cmp			$r1,$r2
	beq			mem_3_short_ok
	bad
mem_3_short_ok:

	# Read byte 0 
	lda.b		$r2,(0x2000)
.if BIG_ENDIAN
	ldi.l		$r3,0x12
.else
	ldi.l		$r3,0x34
.endif
	cmp			$r2,$r3
	beq			mem_3_byte_0_ok
	bad
mem_3_byte_0_ok:

	# Read byte 1
	lda.b		$r2,(0x2001)
.if BIG_ENDIAN
	ldi.l		$r3,0x34
.else
	ldi.l		$r3,0x12
.endif
	cmp			$r2,$r3
	beq			mem_3_byte_1_ok
	bad
mem_3_byte_1_ok:

	## Unaligned Write Short Test ##

	# Write Short
mem_4_test:
	ldi.l		$r1,0x1234
	sta.s		(0x2001), $r1

	# Read short
	lda.s		$r2,(0x2001)
	cmp			$r1,$r2
	beq			mem_4_short_ok
	bad
mem_4_short_ok:

	# Read byte 0 
	lda.b		$r2,(0x2001)
.if BIG_ENDIAN
	ldi.l		$r3,0x12
.else
	ldi.l		$r3,0x34
.endif
	cmp			$r2,$r3
	beq			mem_4_byte_0_ok
	bad
mem_4_byte_0_ok:

	# Read byte 1
	lda.b		$r2,(0x2002)
.if BIG_ENDIAN
	ldi.l		$r3,0x34
.else
	ldi.l		$r3,0x12
.endif
	cmp			$r2,$r3
	beq			mem_4_byte_1_ok
	bad
mem_4_byte_1_ok:


	## Aligned Write Byte Test ##

	# Write Byte
mem_5_test:
	ldi.l		$r1,0x12
	sta.b		(0x2000), $r1

	# Read Byte
	lda.b		$r2,(0x2000)
	cmp			$r1,$r2
	beq			mem_5_ok
	bad
mem_5_ok:


	## Unaligned Write Byte Test ##

	# Write Byte
mem_6_test:
	ldi.l		$r1,0x12
	sta.b		(0x2001), $r1

	# Read Byte
	lda.b		$r2,(0x2001)
	cmp			$r1,$r2
	beq			mem_6_ok
	bad
mem_6_ok:


	## Test that writing an unaligned long doesn't corrupt the byte before or after

mem_7_test:
	# Write test pattern
	ldi.l		$r1,0xAAAAAAAA
	sta.l		(0x2000),$r1
	sta.l		(0x2004),$r1

	# Write unaligned long
	ldi.l		$r1,0x12345678
	sta.l		(0x2001),$r1

	# Test byte before
	lda.b		$r1,(0x2000)
	ldi.l		$r2,0xAA
	cmp			$r1,$r2
	beq			mem_7_1_ok
	bad
mem_7_1_ok:

	# Test byte after
	lda.b		$r1,(0x2005)
	cmp			$r1,$r2
	beq			mem_7_2_ok
	bad
mem_7_2_ok:



	## Test that writing an unaligned short doesn't corrupt the byte before or after

mem_8_test:
	# Write test pattern
	ldi.l		$r1,0xAAAAAAAA
	sta.l		(0x2000),$r1

	# Write unaligned short
	ldi.l		$r1,0x1234
	sta.s		(0x2001),$r1

	# Test byte before
	lda.b		$r1,(0x2000)
	ldi.l		$r2,0xAA
	cmp			$r1,$r2
	beq			mem_8_1_ok
	bad
mem_8_1_ok:

	# Test byte after
	lda.b		$r1,(0x2003)
	cmp			$r1,$r2
	beq			mem_8_2_ok
	bad
mem_8_2_ok:

	## Test that writing an aligned byte doesn't corrupt the byte after

mem_9_test:
	# Write test pattern
	ldi.l		$r1,0xAAAAAAAA
	sta.l		(0x2000),$r1

	# Write aligned byte
	ldi.l		$r1,0x12
	sta.b		(0x2000),$r1

	# Test byte before
	lda.b		$r1,(0x2001)
	ldi.l		$r2,0xAA
	cmp			$r1,$r2
	beq			mem_9_ok
	bad
mem_9_ok:


	## Test that writing an unaligned byte doesn't corrupt the byte before

mem_10_test:
	# Write test pattern
	ldi.l		$r1,0xAAAAAAAA
	sta.l		(0x2000),$r1

	# Write unaligned byte
	ldi.l		$r1,0x12
	sta.b		(0x2001),$r1

	# Test byte before
	lda.b		$r1,(0x2000)
	ldi.l		$r2,0xAA
	cmp			$r1,$r2
	beq			mem_10_ok
	bad
mem_10_ok:



	############ LD/ST Tests ##############

	# For these test we just test the the read/write occurs at the correct location
	# and assume the alignment and corrupted byte before/after tests aren't needed

	# ST.L/LD.L
mem_11_test:
	ldi.l		$r1,0x2010
	ldi.l		$r2,0x12345678
	st.l		($r1),$r2			#
	ld.l		$r3,($r1)			#
	cmp			$r3,$r2
	beq			mem_11_1_ok
	bad
mem_11_1_ok:
	lda.l		$r3,(0x2010)
	cmp			$r3,$r2
	beq			mem_11_2_ok
	bad
mem_11_2_ok:

	# ST.S/LD.S
mem_12_test:
	ldi.l		$r1,0x2020
	ldi.l		$r2,0x1234
	st.s		($r1),$r2			#
	ld.s		$r3,($r1)			#
	cmp			$r3,$r2
	beq			mem_12_1_ok
	bad
mem_12_1_ok:
	lda.s		$r3,(0x2020)
	cmp			$r3,$r2
	beq			mem_12_2_ok
	bad
mem_12_2_ok:

	# ST.B/LD.B
mem_13_test:
	ldi.l		$r1,0x2030
	ldi.l		$r2,0x12
	st.b		($r1),$r2			#
	ld.b		$r3,($r1)			#
	cmp			$r3,$r2
	beq			mem_13_1_ok
	bad
mem_13_1_ok:
	lda.b		$r3,(0x2030)
	cmp			$r3,$r2
	beq			mem_13_2_ok
	bad
mem_13_2_ok:


	############ LDO/STO Tests ##############

	# For these test we just test the the read/write occurs at the correct location
	# and assume the alignment and corrupted byte before/after tests aren't needed

	# STO.L/LDO.L
mem_14_test:
	ldi.l		$r1,0x2110
	ldi.l		$r2,0x12345678
	sto.l		0x100 ($r1),$r2		#
	ldo.l		$r3,0x100 ($r1)		#
	cmp			$r3,$r2
	beq			mem_14_1_ok
	bad
mem_14_1_ok:
	lda.l		$r3,(0x2210)
	cmp			$r3,$r2
	beq			mem_14_2_ok
	bad
mem_14_2_ok:

	# STO.S/LDO.S
mem_15_test:
	ldi.l		$r1,0x2120
	ldi.l		$r2,0x1234
	sto.s		0x100 ($r1),$r2		#
	ldo.s		$r3,0x100 ($r1)		#
	cmp			$r3,$r2
	beq			mem_15_1_ok
	bad
mem_15_1_ok:
	lda.s		$r3,(0x2220)
	cmp			$r3,$r2
	beq			mem_15_2_ok
	bad
mem_15_2_ok:

	# STO.B/LDO.B
mem_16_test:
	ldi.l		$r1,0x2130
	ldi.l		$r2,0x12
	sto.b		0x100 ($r1),$r2		#
	ldo.b		$r3,0x100 ($r1)		#
	cmp			$r3,$r2
	beq			mem_16_1_ok
	bad
mem_16_1_ok:
	lda.b		$r3,(0x2230)
	cmp			$r3,$r2
	beq			mem_16_2_ok
	bad
mem_16_2_ok:

	
	############ JMP/JMPA Tests ##############

jmp_test:
	ldi.l		$r0,jmp_continue
	jmp			$r0
	bad
jmp_continue:

	jmpa		jmp_continue_2
	bad
jmp_continue_2:


	############ PUSH/POP ##############

	ldi.l		$sp,0x2080

stack_test_1:	
	# push
	ldi.l		$r1,100
	push		$sp,$r1

	# check SP
	ldi.l		$r3,0x2080-4
	cmp			$sp,$r3
	beq			stack_test_1_ok_1
	bad
stack_test_1_ok_1:

	# pop and check value
	pop			$sp,$r2
	cmp			$r1,$r2
	beq			stack_test_1_ok_2
	bad
stack_test_1_ok_2:

	# check SP
	ldi.l		$r3,0x2080
	cmp			$sp,$r3
	beq			stack_test_1_ok_3
	bad
stack_test_1_ok_3:


	############ JSR/RET ##############

	jmpa		jsr_test_1

add_fn:
	push		$sp,$r0
	ldo.l		$r1,12 ($fp)
	ldo.l		$r2,16 ($fp)
	add.l		$r1,$r2
	mov			$r12,$fp
	dec			$r12,4
	pop			$r12,$r0
	ret

jsr_test_1:
	ldi.l		$r1,1000
	push		$sp,$r1
	ldi.l		$r1,500
	push		$sp,$r1
	jsra		add_fn
	ldi.l		$r2,1500
	cmp			$r1,$r2
	beq			jsr_test_1_pass
	bad
jsr_test_1_pass:

jsr_test_2:
	ldi.l		$r1,2000
	push		$sp,$r1
	ldi.l		$r1,1000
	push		$sp,$r1
	ldi.l		$r1,add_fn
	jsr			$r1
	ldi.l		$r2,3000
	cmp			$r1,$r2
	beq			jsr_test_2_pass
	bad
jsr_test_2_pass:

	brk

