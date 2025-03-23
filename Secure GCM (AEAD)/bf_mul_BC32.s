
/*
 * bf_mul_BC32.s
 *
 * Created: 2018-07-29 오후 3:28:06
 *  Author: 서석충
 * Block Comb multiplication method for 32-bit X 32-bit -> 64-bit
 * providing constant-time execution with option 1
 */ 

// .arch atmega128

.macro regBackup

	.irp i, 0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 28, 29
		push 	\i
	.endr
	
.endm

.macro regRetrieve

	clr		r1
	.irp i, 29, 28, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 0
		pop 	\i
	.endr
	ret

.endm

.macro shifting_multiplicand_w4
	lsl		r16
	rol		r17
	rol		r18
	rol		r19
	rol		r20
.endm

//.data

//----------------------------------------------------------------------------//
// text part
//----------------------------------------------------------------------------//
.text
.global bf_rtl_comb_32bit_ASM

;--------------------------------------------------------------------------
; RtL Block Comb multiplication
;--------------------------------------------------------------------------

; operand ret <- r25:r24
; operand a <- r23:r22
; operand b <- r21:r20



; X(r27:r26)
; Y(r29:r28)
; Z(r31:r30)

bf_rtl_comb_32bit_ASM:
	regBackup

	// address of operand A
	movw	r0,		r22

	// storing ret's address
	movw	r26,	r24
	
	// Loading B
	movw	r30,	r20		// Z <- B
	ld		r21,	Z
	ldd		r22,	Z+1
	ldd		r23,	Z+2
	ldd		r24,	Z+3

	// Loading A
	movw	r28,	r0
	ld		r16,	Y
	ldd		r17,	Y+1
	ldd		r18,	Y+2
	ldd		r19,	Y+3
	eor		r20,	r20

	; clear registers
	clr		r0
	clr		r1
	movw	r2,		r0
	movw	r4,		r0
	movw	r6,		r0
	movw	r8,		r0
	movw	r10,	r0
	movw	r12,	r0
	movw	r14,	r0

	; l = 0
	; m = 0
	sbrs	r21,	0
	rjmp	l_0_m_0_position_rtl_dummy

	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	;eor	r12, r20
	rjmp	l_0_m_1_position_rtl

l_0_m_0_position_rtl_dummy:
	nop
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	;eor	r4, r20

	; m = 1
l_0_m_1_position_rtl:
	sbrs	r22,	0
	rjmp	l_0_m_1_position_rtl_dummy

	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	;eor	r13, r20
	rjmp	l_0_m_2_position_rtl

l_0_m_1_position_rtl_dummy:
	nop
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	;eor	r5, r20

	; m = 2
l_0_m_2_position_rtl:
	sbrs	r23,	0
	rjmp	l_0_m_2_position_rtl_dummy

	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	;eor	r14, r20
	rjmp	l_0_m_3_position_rtl

l_0_m_2_position_rtl_dummy:
	nop
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	;eor	r6, r20

	; m = 3
l_0_m_3_position_rtl:
	sbrs	r24,	0
	rjmp	l_0_m_3_position_rtl_dummy

	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	;eor	r15, r20
	rjmp	l_0_m_3_position_rtl_end

l_0_m_3_position_rtl_dummy:
	nop
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	;eor	r7, r20

l_0_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 1
	; m = 0
	sbrs	r21,	1
	rjmp	l_1_m_0_position_rtl_dummy

	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	l_1_m_1_position_rtl

l_1_m_0_position_rtl_dummy:
	nop
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20

	; m = 1
l_1_m_1_position_rtl:
	sbrs	r22,	1
	rjmp	l_1_m_1_position_rtl_dummy

	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	l_1_m_2_position_rtl

l_1_m_1_position_rtl_dummy:
	nop
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20

	; m = 2
l_1_m_2_position_rtl:
	sbrs	r23,	1
	rjmp	l_1_m_2_position_rtl_dummy

	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	l_1_m_3_position_rtl

l_1_m_2_position_rtl_dummy:
	nop
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20

	; m = 3
l_1_m_3_position_rtl:
	sbrs	r24,	1
	rjmp	l_1_m_3_position_rtl_dummy

	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	l_1_m_3_position_rtl_end

l_1_m_3_position_rtl_dummy:
	nop
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20

l_1_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 2
	; m = 0
	sbrs	r21,	2
	rjmp	l_2_m_0_position_rtl_dummy

	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	l_2_m_1_position_rtl

l_2_m_0_position_rtl_dummy:
	nop
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20

	; m = 1
l_2_m_1_position_rtl:
	sbrs	r22,	2
	rjmp	l_2_m_1_position_rtl_dummy

	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	l_2_m_2_position_rtl

l_2_m_1_position_rtl_dummy:
	nop
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20

	; m = 2
l_2_m_2_position_rtl:
	sbrs	r23,	2
	rjmp	l_2_m_2_position_rtl_dummy

	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	l_2_m_3_position_rtl

l_2_m_2_position_rtl_dummy:
	nop
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20

	; m = 3
l_2_m_3_position_rtl:
	sbrs	r24,	2
	rjmp	l_2_m_3_position_rtl_dummy

	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	l_2_m_3_position_rtl_end

l_2_m_3_position_rtl_dummy:
	nop
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20

l_2_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 3
	; m = 0
	sbrs	r21,	3
	rjmp	l_3_m_0_position_rtl_dummy

	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	l_3_m_1_position_rtl

l_3_m_0_position_rtl_dummy:
	nop
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20

	; m = 1
l_3_m_1_position_rtl:
	sbrs	r22,	3
	rjmp	l_3_m_1_position_rtl_dummy

	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	l_3_m_2_position_rtl

l_3_m_1_position_rtl_dummy:
	nop
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20

	; m = 2
l_3_m_2_position_rtl:
	sbrs	r23,	3
	rjmp	l_3_m_2_position_rtl_dummy

	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	l_3_m_3_position_rtl

l_3_m_2_position_rtl_dummy:
	nop
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20

	; m = 3
l_3_m_3_position_rtl:
	sbrs	r24,	3
	rjmp	l_3_m_3_position_rtl_dummy

	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	l_3_m_3_position_rtl_end

l_3_m_3_position_rtl_dummy:
	nop
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20

l_3_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 4
	; m = 0
	sbrs	r21,	4
	rjmp	l_4_m_0_position_rtl_dummy

	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	l_4_m_1_position_rtl

l_4_m_0_position_rtl_dummy:
	nop
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20

	; m = 1
l_4_m_1_position_rtl:
	sbrs	r22,	4
	rjmp	l_4_m_1_position_rtl_dummy

	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	l_4_m_2_position_rtl

l_4_m_1_position_rtl_dummy:
	nop
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20

	; m = 2
l_4_m_2_position_rtl:
	sbrs	r23,	4
	rjmp	l_4_m_2_position_rtl_dummy

	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	l_4_m_3_position_rtl

l_4_m_2_position_rtl_dummy:
	nop
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20

	; m = 3
l_4_m_3_position_rtl:
	sbrs	r24,	4
	rjmp	l_4_m_3_position_rtl_dummy

	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	l_4_m_3_position_rtl_end

l_4_m_3_position_rtl_dummy:
	nop
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20

l_4_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 5
	; m = 0
	sbrs	r21,	5
	rjmp	l_5_m_0_position_rtl_dummy

	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	l_5_m_1_position_rtl

l_5_m_0_position_rtl_dummy:
	nop
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20

	; m = 1
l_5_m_1_position_rtl:
	sbrs	r22,	5
	rjmp	l_5_m_1_position_rtl_dummy

	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	l_5_m_2_position_rtl

l_5_m_1_position_rtl_dummy:
	nop
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20

	; m = 2
l_5_m_2_position_rtl:
	sbrs	r23,	5
	rjmp	l_5_m_2_position_rtl_dummy

	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	l_5_m_3_position_rtl

l_5_m_2_position_rtl_dummy:
	nop
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20

	; m = 3
l_5_m_3_position_rtl:
	sbrs	r24,	5
	rjmp	l_5_m_3_position_rtl_dummy

	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	l_5_m_3_position_rtl_end

l_5_m_3_position_rtl_dummy:
	nop
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20

l_5_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 6
	; m = 0
	sbrs	r21,	6
	rjmp	l_6_m_0_position_rtl_dummy

	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	l_6_m_1_position_rtl

l_6_m_0_position_rtl_dummy:
	nop
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20

	; m = 1
l_6_m_1_position_rtl:
	sbrs	r22,	6
	rjmp	l_6_m_1_position_rtl_dummy

	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	l_6_m_2_position_rtl

l_6_m_1_position_rtl_dummy:
	nop
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20

	; m = 2
l_6_m_2_position_rtl:
	sbrs	r23,	6
	rjmp	l_6_m_2_position_rtl_dummy

	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	l_6_m_3_position_rtl

l_6_m_2_position_rtl_dummy:
	nop
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20

	; m = 3
l_6_m_3_position_rtl:
	sbrs	r24,	6
	rjmp	l_6_m_3_position_rtl_dummy

	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	l_6_m_3_position_rtl_end

l_6_m_3_position_rtl_dummy:
	nop
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20

l_6_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 7
	; m = 0
	sbrs	r21,	7
	rjmp	l_7_m_0_position_rtl_dummy

	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	l_7_m_1_position_rtl

l_7_m_0_position_rtl_dummy:
	nop
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20

	; m = 1
l_7_m_1_position_rtl:
	sbrs	r22,	7
	rjmp	l_7_m_1_position_rtl_dummy

	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	l_7_m_2_position_rtl

l_7_m_1_position_rtl_dummy:
	nop
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20

	; m = 2
l_7_m_2_position_rtl:
	sbrs	r23,	7
	rjmp	l_7_m_2_position_rtl_dummy

	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	l_7_m_3_position_rtl

l_7_m_2_position_rtl_dummy:
	nop
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20

	; m = 3
l_7_m_3_position_rtl:
	sbrs	r24,	7
	rjmp	l_7_m_3_position_rtl_dummy

	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	l_7_m_3_position_rtl_end

l_7_m_3_position_rtl_dummy:
	nop
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20

l_7_m_3_position_rtl_end:

	st		X+,	r8
	st		X+,	r9
	st		X+,	r10
	st		X+,	r11
	st		X+,	r12
	st		X+,	r13
	st		X+,	r14
	st		X+,	r15

	regRetrieve
	ret