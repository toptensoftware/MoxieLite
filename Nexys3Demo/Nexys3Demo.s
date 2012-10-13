	.text
	.p2align	1
	.global	_start

_start:

	# Setup stack
	ldi.l		$sp,_stack
	ldi.l		$r0,0x02

L1:
	sta.b		(0x80000000),$r0
	jsra		delay
	ldi.l		$r1,1
	ashl		$r0,$r1
	ldi.l		$r1,0x100
	cmp			$r0,$r1
	bne			L1
	ldi.l		$r0,0x01
	jmpa		L1



delay:
	ldi.l		$r1,100000
	ldi.l		$r2,0
L2:
	dec			$r1,1
	cmp			$r1,$r2
	bne			L2
	ret
