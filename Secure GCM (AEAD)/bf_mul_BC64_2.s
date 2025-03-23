
/*
 * bf_mul_BC64_2.s
 *
 * Created: 2018-08-07 오후 2:00:12
 *  Author: 서석충
 * Block Comb multiplication method for 64-bit X 64-bit -> 128-bit
 * providing constant-time execution with option 2
 */ 

//.arch atmega128

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

.data

//----------------------------------------------------------------------------//
// text part
//----------------------------------------------------------------------------//
.text
.global bf_kara_rtl_comb_64bit_ASM_Ver2

;--------------------------------------------------------------------------
; RtL Block Comb multiplication
;--------------------------------------------------------------------------

; operand ret <- r25:r24
; operand a <- r23:r22
; operand b <- r21:r20


; X(r27:r26)
; Y(r29:r28)
; Z(r31:r30)

bf_kara_rtl_comb_64bit_ASM_Ver2:
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
	;movw	r2,		r0
	;movw	r4,		r0
	;movw	r6,		r0
	movw	r8,		r0
	movw	r10,	r0
	movw	r12,	r0
	movw	r14,	r0

	//-------------------------------------------------------------------------------
	// 1. C[7...0] = A[3...0] X B[3...0]
	//-------------------------------------------------------------------------------

	; l = 0
	; m = 0
	sbrs	r21,	0
	rjmp	p1_l_0_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	rjmp	p1_l_0_m_1_position_rtl

p1_l_0_m_0_position_rtl_dummy:
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	rjmp	p1_l_0_m_1_position_rtl

	; m = 1
p1_l_0_m_1_position_rtl:
	sbrs	r22,	0
	rjmp	p1_l_0_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	rjmp	p1_l_0_m_2_position_rtl

p1_l_0_m_1_position_rtl_dummy:
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	rjmp	p1_l_0_m_2_position_rtl

	; m = 2
p1_l_0_m_2_position_rtl:
	sbrs	r23,	0
	rjmp	p1_l_0_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	;eor	r14, r20
	rjmp	p1_l_0_m_3_position_rtl

p1_l_0_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	;eor	r6, r20
	rjmp	p1_l_0_m_3_position_rtl

	; m = 3
p1_l_0_m_3_position_rtl:
	sbrs	r24,	0
	rjmp	p1_l_0_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	;eor	r15, r20
	rjmp	p1_l_0_m_3_position_rtl_end

p1_l_0_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	;eor	r7, r20
	rjmp	p1_l_0_m_3_position_rtl_end

p1_l_0_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 1
	; m = 0
	sbrs	r21,	1
	rjmp	p1_l_1_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p1_l_1_m_1_position_rtl

p1_l_1_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p1_l_1_m_1_position_rtl

	; m = 1
p1_l_1_m_1_position_rtl:
	sbrs	r22,	1
	rjmp	p1_l_1_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p1_l_1_m_2_position_rtl

p1_l_1_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p1_l_1_m_2_position_rtl

	; m = 2
p1_l_1_m_2_position_rtl:
	sbrs	r23,	1
	rjmp	p1_l_1_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p1_l_1_m_3_position_rtl

p1_l_1_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p1_l_1_m_3_position_rtl

	; m = 3
p1_l_1_m_3_position_rtl:
	sbrs	r24,	1
	rjmp	p1_l_1_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p1_l_1_m_3_position_rtl_end

p1_l_1_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p1_l_1_m_3_position_rtl_end

p1_l_1_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 2
	; m = 0
	sbrs	r21,	2
	rjmp	p1_l_2_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p1_l_2_m_1_position_rtl

p1_l_2_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p1_l_2_m_1_position_rtl

	; m = 1
p1_l_2_m_1_position_rtl:
	sbrs	r22,	2
	rjmp	p1_l_2_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p1_l_2_m_2_position_rtl

p1_l_2_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p1_l_2_m_2_position_rtl

	; m = 2
p1_l_2_m_2_position_rtl:
	sbrs	r23,	2
	rjmp	p1_l_2_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p1_l_2_m_3_position_rtl

p1_l_2_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p1_l_2_m_3_position_rtl

	; m = 3
p1_l_2_m_3_position_rtl:
	sbrs	r24,	2
	rjmp	p1_l_2_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p1_l_2_m_3_position_rtl_end

p1_l_2_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p1_l_2_m_3_position_rtl_end

p1_l_2_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 3
	; m = 0
	sbrs	r21,	3
	rjmp	p1_l_3_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p1_l_3_m_1_position_rtl

p1_l_3_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p1_l_3_m_1_position_rtl

	; m = 1
p1_l_3_m_1_position_rtl:
	sbrs	r22,	3
	rjmp	p1_l_3_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p1_l_3_m_2_position_rtl

p1_l_3_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p1_l_3_m_2_position_rtl

	; m = 2
p1_l_3_m_2_position_rtl:
	sbrs	r23,	3
	rjmp	p1_l_3_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p1_l_3_m_3_position_rtl

p1_l_3_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p1_l_3_m_3_position_rtl

	; m = 3
p1_l_3_m_3_position_rtl:
	sbrs	r24,	3
	rjmp	p1_l_3_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p1_l_3_m_3_position_rtl_end

p1_l_3_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p1_l_3_m_3_position_rtl_end

p1_l_3_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 4
	; m = 0
	sbrs	r21,	4
	rjmp	p1_l_4_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p1_l_4_m_1_position_rtl

p1_l_4_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p1_l_4_m_1_position_rtl

	; m = 1
p1_l_4_m_1_position_rtl:
	sbrs	r22,	4
	rjmp	p1_l_4_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p1_l_4_m_2_position_rtl

p1_l_4_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p1_l_4_m_2_position_rtl

	; m = 2
p1_l_4_m_2_position_rtl:
	sbrs	r23,	4
	rjmp	p1_l_4_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p1_l_4_m_3_position_rtl

p1_l_4_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p1_l_4_m_3_position_rtl

	; m = 3
p1_l_4_m_3_position_rtl:
	sbrs	r24,	4
	rjmp	p1_l_4_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p1_l_4_m_3_position_rtl_end

p1_l_4_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p1_l_4_m_3_position_rtl_end

p1_l_4_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 5
	; m = 0
	sbrs	r21,	5
	rjmp	p1_l_5_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p1_l_5_m_1_position_rtl

p1_l_5_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p1_l_5_m_1_position_rtl

	; m = 1
p1_l_5_m_1_position_rtl:
	sbrs	r22,	5
	rjmp	p1_l_5_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p1_l_5_m_2_position_rtl

p1_l_5_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p1_l_5_m_2_position_rtl

	; m = 2
p1_l_5_m_2_position_rtl:
	sbrs	r23,	5
	rjmp	p1_l_5_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p1_l_5_m_3_position_rtl

p1_l_5_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p1_l_5_m_3_position_rtl

	; m = 3
p1_l_5_m_3_position_rtl:
	sbrs	r24,	5
	rjmp	p1_l_5_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p1_l_5_m_3_position_rtl_end

p1_l_5_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p1_l_5_m_3_position_rtl_end

p1_l_5_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 6
	; m = 0
	sbrs	r21,	6
	rjmp	p1_l_6_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p1_l_6_m_1_position_rtl

p1_l_6_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p1_l_6_m_1_position_rtl

	; m = 1
p1_l_6_m_1_position_rtl:
	sbrs	r22,	6
	rjmp	p1_l_6_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p1_l_6_m_2_position_rtl

p1_l_6_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p1_l_6_m_2_position_rtl

	; m = 2
p1_l_6_m_2_position_rtl:
	sbrs	r23,	6
	rjmp	p1_l_6_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p1_l_6_m_3_position_rtl

p1_l_6_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p1_l_6_m_3_position_rtl

	; m = 3
p1_l_6_m_3_position_rtl:
	sbrs	r24,	6
	rjmp	p1_l_6_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p1_l_6_m_3_position_rtl_end

p1_l_6_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p1_l_6_m_3_position_rtl_end

p1_l_6_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 7
	; m = 0
	sbrs	r21,	7
	rjmp	p1_l_7_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p1_l_7_m_1_position_rtl

p1_l_7_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p1_l_7_m_1_position_rtl

	; m = 1
p1_l_7_m_1_position_rtl:
	sbrs	r22,	7
	rjmp	p1_l_7_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p1_l_7_m_2_position_rtl

p1_l_7_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p1_l_7_m_2_position_rtl

	; m = 2
p1_l_7_m_2_position_rtl:
	sbrs	r23,	7
	rjmp	p1_l_7_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p1_l_7_m_3_position_rtl

p1_l_7_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p1_l_7_m_3_position_rtl

	; m = 3
p1_l_7_m_3_position_rtl:
	sbrs	r24,	7
	rjmp	p1_l_7_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p1_l_7_m_3_position_rtl_end

p1_l_7_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p1_l_7_m_3_position_rtl_end

p1_l_7_m_3_position_rtl_end:

	st		X+,	r8
	st		X+,	r9
	st		X+,	r10
	st		X+,	r11
	st		X+,	r12
	st		X+,	r13
	st		X+,	r14
	st		X+,	r15

	//-------------------------------------------------------------------------------
	// 2. C[15...8] = A[7...4] X B[7...4]
	//-------------------------------------------------------------------------------

	// Loading B
	ldd		r21,	Z+4
	ldd		r22,	Z+5
	ldd		r23,	Z+6
	ldd		r24,	Z+7

	// Loading A
	ldd		r16,	Y+4
	ldd		r17,	Y+5
	ldd		r18,	Y+6
	ldd		r19,	Y+7
	eor		r20,	r20

	; clear registers
	clr		r0
	clr		r1
	movw	r8,		r0
	movw	r10,	r0
	movw	r12,	r0
	movw	r14,	r0

	; l = 0
	; m = 0
	sbrs	r21,	0
	rjmp	p2_l_0_m_0_position_rtl_dummy
	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	;eor	r12, r20
	rjmp	p2_l_0_m_1_position_rtl

p2_l_0_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	;eor	r4, r20
	rjmp	p2_l_0_m_1_position_rtl

	; m = 1
p2_l_0_m_1_position_rtl:
	sbrs	r22,	0
	rjmp	p2_l_0_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	;eor	r13, r20
	rjmp	p2_l_0_m_2_position_rtl

p2_l_0_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	;eor	r5, r20
	rjmp	p2_l_0_m_2_position_rtl

	; m = 2
p2_l_0_m_2_position_rtl:
	sbrs	r23,	0
	rjmp	p2_l_0_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	;eor	r14, r20
	rjmp	p2_l_0_m_3_position_rtl

p2_l_0_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	;eor	r6, r20
	rjmp	p2_l_0_m_3_position_rtl

	; m = 3
p2_l_0_m_3_position_rtl:
	sbrs	r24,	0
	rjmp	p2_l_0_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	;eor	r15, r20
	rjmp	p2_l_0_m_3_position_rtl_end

p2_l_0_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	;eor	r7, r20
	rjmp	p2_l_0_m_3_position_rtl_end

p2_l_0_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 1
	; m = 0
	sbrs	r21,	1
	rjmp	p2_l_1_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p2_l_1_m_1_position_rtl

p2_l_1_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p2_l_1_m_1_position_rtl

	; m = 1
p2_l_1_m_1_position_rtl:
	sbrs	r22,	1
	rjmp	p2_l_1_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p2_l_1_m_2_position_rtl

p2_l_1_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p2_l_1_m_2_position_rtl

	; m = 2
p2_l_1_m_2_position_rtl:
	sbrs	r23,	1
	rjmp	p2_l_1_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p2_l_1_m_3_position_rtl

p2_l_1_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p2_l_1_m_3_position_rtl

	; m = 3
p2_l_1_m_3_position_rtl:
	sbrs	r24,	1
	rjmp	p2_l_1_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p2_l_1_m_3_position_rtl_end

p2_l_1_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p2_l_1_m_3_position_rtl_end

p2_l_1_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 2
	; m = 0
	sbrs	r21,	2
	rjmp	p2_l_2_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p2_l_2_m_1_position_rtl

p2_l_2_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p2_l_2_m_1_position_rtl

	; m = 1
p2_l_2_m_1_position_rtl:
	sbrs	r22,	2
	rjmp	p2_l_2_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p2_l_2_m_2_position_rtl

p2_l_2_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p2_l_2_m_2_position_rtl


	; m = 2
p2_l_2_m_2_position_rtl:
	sbrs	r23,	2
	rjmp	p2_l_2_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p2_l_2_m_3_position_rtl

p2_l_2_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p2_l_2_m_3_position_rtl

	; m = 3
p2_l_2_m_3_position_rtl:
	sbrs	r24,	2
	rjmp	p2_l_2_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p2_l_2_m_3_position_rtl_end

p2_l_2_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p2_l_2_m_3_position_rtl_end

p2_l_2_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 3
	; m = 0
	sbrs	r21,	3
	rjmp	p2_l_3_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p2_l_3_m_1_position_rtl

p2_l_3_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p2_l_3_m_1_position_rtl

	; m = 1
p2_l_3_m_1_position_rtl:
	sbrs	r22,	3
	rjmp	p2_l_3_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p2_l_3_m_2_position_rtl

p2_l_3_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p2_l_3_m_2_position_rtl

	; m = 2
p2_l_3_m_2_position_rtl:
	sbrs	r23,	3
	rjmp	p2_l_3_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p2_l_3_m_3_position_rtl

p2_l_3_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p2_l_3_m_3_position_rtl

	; m = 3
p2_l_3_m_3_position_rtl:
	sbrs	r24,	3
	rjmp	p2_l_3_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p2_l_3_m_3_position_rtl_end

p2_l_3_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p2_l_3_m_3_position_rtl_end

p2_l_3_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 4
	; m = 0
	sbrs	r21,	4
	rjmp	p2_l_4_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p2_l_4_m_1_position_rtl

p2_l_4_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p2_l_4_m_1_position_rtl

	; m = 1
p2_l_4_m_1_position_rtl:
	sbrs	r22,	4
	rjmp	p2_l_4_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p2_l_4_m_2_position_rtl

p2_l_4_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p2_l_4_m_2_position_rtl

	; m = 2
p2_l_4_m_2_position_rtl:
	sbrs	r23,	4
	rjmp	p2_l_4_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p2_l_4_m_3_position_rtl

p2_l_4_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p2_l_4_m_3_position_rtl

	; m = 3
p2_l_4_m_3_position_rtl:
	sbrs	r24,	4
	rjmp	p2_l_4_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p2_l_4_m_3_position_rtl_end

p2_l_4_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p2_l_4_m_3_position_rtl_end

p2_l_4_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 5
	; m = 0
	sbrs	r21,	5
	rjmp	p2_l_5_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p2_l_5_m_1_position_rtl

p2_l_5_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p2_l_5_m_1_position_rtl

	; m = 1
p2_l_5_m_1_position_rtl:
	sbrs	r22,	5
	rjmp	p2_l_5_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p2_l_5_m_2_position_rtl

p2_l_5_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p2_l_5_m_2_position_rtl

	; m = 2
p2_l_5_m_2_position_rtl:
	sbrs	r23,	5
	rjmp	p2_l_5_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p2_l_5_m_3_position_rtl

p2_l_5_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p2_l_5_m_3_position_rtl

	; m = 3
p2_l_5_m_3_position_rtl:
	sbrs	r24,	5
	rjmp	p2_l_5_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p2_l_5_m_3_position_rtl_end

p2_l_5_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p2_l_5_m_3_position_rtl_end

p2_l_5_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 6
	; m = 0
	sbrs	r21,	6
	rjmp	p2_l_6_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p2_l_6_m_1_position_rtl

p2_l_6_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p2_l_6_m_1_position_rtl

	; m = 1
p2_l_6_m_1_position_rtl:
	sbrs	r22,	6
	rjmp	p2_l_6_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p2_l_6_m_2_position_rtl

p2_l_6_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p2_l_6_m_2_position_rtl

	; m = 2
p2_l_6_m_2_position_rtl:
	sbrs	r23,	6
	rjmp	p2_l_6_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p2_l_6_m_3_position_rtl

p2_l_6_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p2_l_6_m_3_position_rtl

	; m = 3
p2_l_6_m_3_position_rtl:
	sbrs	r24,	6
	rjmp	p2_l_6_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p2_l_6_m_3_position_rtl_end

p2_l_6_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p2_l_6_m_3_position_rtl_end

p2_l_6_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 7
	; m = 0
	sbrs	r21,	7
	rjmp	p2_l_7_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p2_l_7_m_1_position_rtl

p2_l_7_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p2_l_7_m_1_position_rtl

	; m = 1
p2_l_7_m_1_position_rtl:
	sbrs	r22,	7
	rjmp	p2_l_7_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p2_l_7_m_2_position_rtl

p2_l_7_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p2_l_7_m_2_position_rtl

	; m = 2
p2_l_7_m_2_position_rtl:
	sbrs	r23,	7
	rjmp	p2_l_7_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p2_l_7_m_3_position_rtl

p2_l_7_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p2_l_7_m_3_position_rtl

	; m = 3
p2_l_7_m_3_position_rtl:
	sbrs	r24,	7
	rjmp	p2_l_7_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p2_l_7_m_3_position_rtl_end

p2_l_7_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p2_l_7_m_3_position_rtl_end

p2_l_7_m_3_position_rtl_end:

	st		X+,	r8
	st		X+,	r9
	st		X+,	r10
	st		X+,	r11
	st		X+,	r12
	st		X+,	r13
	st		X+,	r14
	st		X+,	r15

	//-------------------------------------------------------------------------------
	// 3. C[11...4] = (A[7...4] xor A[3...0]) X (B[7...4] xor B[3...0]) xor 1's result and 2's result
	//-------------------------------------------------------------------------------
	
	; clear registers
	;clr		r0
	;clr		r1
	;movw	r8,		r0
	;movw	r10,	r0
	;movw	r12,	r0
	;movw	r14,	r0

	subi	r26,	0x10
	sbci	r27,	0x00

	ld		r0,		X+
	eor		r8,		r0
	ld		r0,		X+
	eor		r9,		r0
	ld		r0,		X+
	eor		r10,	r0
	ld		r0,		X+
	eor		r11,	r0
	ld		r0,		X+
	eor		r12,	r0
	ld		r0,		X+
	eor		r13,	r0
	ld		r0,		X+
	eor		r14,	r0
	ld		r0,		X+
	eor		r15,	r0

	;ld		r0,		X+
	;eor		r8,		r0
	;ld		r0,		X+
	;eor		r9,		r0
	;ld		r0,		X+
	;eor		r10,	r0
	;ld		r0,		X+
	;eor		r11,	r0
	;ld		r0,		X+
	;eor		r12,	r0
	;ld		r0,		X+
	;eor		r13,	r0
	;ld		r0,		X+
	;eor		r14,	r0
	;ld		r0,		X+
	;eor		r15,	r0
	
	// Loading B
	;ldd		r21,	Z+4
	;ldd		r22,	Z+5
	;ldd		r23,	Z+6
	;ldd		r24,	Z+7

	ld		r0,		Z
	eor		r21,	r0
	ldd		r0,		Z+1
	eor		r22,	r0
	ldd		r0,		Z+2
	eor		r23,	r0
	ldd		r0,		Z+3
	eor		r24,	r0

	// Loading A
	ldd		r16,	Y+4
	ldd		r17,	Y+5
	ldd		r18,	Y+6
	ldd		r19,	Y+7

	ld		r0,		Y
	eor		r16,	r0
	ldd		r0,		Y+1
	eor		r17,	r0
	ldd		r0,		Y+2
	eor		r18,	r0
	ldd		r0,		Y+3
	eor		r19,	r0

	eor		r20,	r20

	; l = 0
	; m = 0
	sbrs	r21,	0
	rjmp	p3_l_0_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	;eor	r12, r20
	rjmp	p3_l_0_m_1_position_rtl

p3_l_0_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	;eor	r4, r20
	rjmp	p3_l_0_m_1_position_rtl

	; m = 1
p3_l_0_m_1_position_rtl:
	sbrs	r22,	0
	rjmp	p3_l_0_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	;eor	r13, r20
	rjmp	p3_l_0_m_2_position_rtl

p3_l_0_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	;eor	r5, r20
	rjmp	p3_l_0_m_2_position_rtl

	; m = 2
p3_l_0_m_2_position_rtl:
	sbrs	r23,	0
	rjmp	p3_l_0_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	;eor	r14, r20
	rjmp	p3_l_0_m_3_position_rtl

p3_l_0_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	;eor	r6, r20
	rjmp	p3_l_0_m_3_position_rtl

	; m = 3
p3_l_0_m_3_position_rtl:
	sbrs	r24,	0
	rjmp	p3_l_0_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	;eor	r15, r20
	rjmp	p3_l_0_m_3_position_rtl_end

p3_l_0_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	;eor	r7, r20
	rjmp	p3_l_0_m_3_position_rtl_end

p3_l_0_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 1
	; m = 0
	sbrs	r21,	1
	rjmp	p3_l_1_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p3_l_1_m_1_position_rtl

p3_l_1_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p3_l_1_m_1_position_rtl

	; m = 1
p3_l_1_m_1_position_rtl:
	sbrs	r22,	1
	rjmp	p3_l_1_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p3_l_1_m_2_position_rtl

p3_l_1_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p3_l_1_m_2_position_rtl

	; m = 2
p3_l_1_m_2_position_rtl:
	sbrs	r23,	1
	rjmp	p3_l_1_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p3_l_1_m_3_position_rtl

p3_l_1_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p3_l_1_m_3_position_rtl

	; m = 3
p3_l_1_m_3_position_rtl:
	sbrs	r24,	1
	rjmp	p3_l_1_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p3_l_1_m_3_position_rtl_end

p3_l_1_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p3_l_1_m_3_position_rtl_end

p3_l_1_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 2
	; m = 0
	sbrs	r21,	2
	rjmp	p3_l_2_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p3_l_2_m_1_position_rtl

p3_l_2_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p3_l_2_m_1_position_rtl

	; m = 1
p3_l_2_m_1_position_rtl:
	sbrs	r22,	2
	rjmp	p3_l_2_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p3_l_2_m_2_position_rtl

p3_l_2_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p3_l_2_m_2_position_rtl

	; m = 2
p3_l_2_m_2_position_rtl:
	sbrs	r23,	2
	rjmp	p3_l_2_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p3_l_2_m_3_position_rtl

p3_l_2_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p3_l_2_m_3_position_rtl

	; m = 3
p3_l_2_m_3_position_rtl:
	sbrs	r24,	2
	rjmp	p3_l_2_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p3_l_2_m_3_position_rtl_end

p3_l_2_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p3_l_2_m_3_position_rtl_end

p3_l_2_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 3
	; m = 0
	sbrs	r21,	3
	rjmp	p3_l_3_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p3_l_3_m_1_position_rtl

p3_l_3_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p3_l_3_m_1_position_rtl

	; m = 1
p3_l_3_m_1_position_rtl:
	sbrs	r22,	3
	rjmp	p3_l_3_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p3_l_3_m_2_position_rtl

p3_l_3_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p3_l_3_m_2_position_rtl

	; m = 2
p3_l_3_m_2_position_rtl:
	sbrs	r23,	3
	rjmp	p3_l_3_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p3_l_3_m_3_position_rtl

p3_l_3_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p3_l_3_m_3_position_rtl

	; m = 3
p3_l_3_m_3_position_rtl:
	sbrs	r24,	3
	rjmp	p3_l_3_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p3_l_3_m_3_position_rtl_end

p3_l_3_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p3_l_3_m_3_position_rtl_end

p3_l_3_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 4
	; m = 0
	sbrs	r21,	4
	rjmp	p3_l_4_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p3_l_4_m_1_position_rtl

p3_l_4_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p3_l_4_m_1_position_rtl

	; m = 1
p3_l_4_m_1_position_rtl:
	sbrs	r22,	4
	rjmp	p3_l_4_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p3_l_4_m_2_position_rtl

p3_l_4_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p3_l_4_m_2_position_rtl

	; m = 2
p3_l_4_m_2_position_rtl:
	sbrs	r23,	4
	rjmp	p3_l_4_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p3_l_4_m_3_position_rtl

p3_l_4_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p3_l_4_m_3_position_rtl

	; m = 3
p3_l_4_m_3_position_rtl:
	sbrs	r24,	4
	rjmp	p3_l_4_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p3_l_4_m_3_position_rtl_end

p3_l_4_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p3_l_4_m_3_position_rtl_end

p3_l_4_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 5
	; m = 0
	sbrs	r21,	5
	rjmp	p3_l_5_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p3_l_5_m_1_position_rtl

p3_l_5_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p3_l_5_m_1_position_rtl

	; m = 1
p3_l_5_m_1_position_rtl:
	sbrs	r22,	5
	rjmp	p3_l_5_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p3_l_5_m_2_position_rtl

p3_l_5_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p3_l_5_m_2_position_rtl

	; m = 2
p3_l_5_m_2_position_rtl:
	sbrs	r23,	5
	rjmp	p3_l_5_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p3_l_5_m_3_position_rtl

p3_l_5_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p3_l_5_m_3_position_rtl

	; m = 3
p3_l_5_m_3_position_rtl:
	sbrs	r24,	5
	rjmp	p3_l_5_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p3_l_5_m_3_position_rtl_end

p3_l_5_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p3_l_5_m_3_position_rtl_end

p3_l_5_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 6
	; m = 0
	sbrs	r21,	6
	rjmp	p3_l_6_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p3_l_6_m_1_position_rtl

p3_l_6_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p3_l_6_m_1_position_rtl

	; m = 1
p3_l_6_m_1_position_rtl:
	sbrs	r22,	6
	rjmp	p3_l_6_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p3_l_6_m_2_position_rtl

p3_l_6_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p3_l_6_m_2_position_rtl

	; m = 2
p3_l_6_m_2_position_rtl:
	sbrs	r23,	6
	rjmp	p3_l_6_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p3_l_6_m_3_position_rtl

p3_l_6_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p3_l_6_m_3_position_rtl

	; m = 3
p3_l_6_m_3_position_rtl:
	sbrs	r24,	6
	rjmp	p3_l_6_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p3_l_6_m_3_position_rtl_end

p3_l_6_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p3_l_6_m_3_position_rtl_end

p3_l_6_m_3_position_rtl_end:
	shifting_multiplicand_w4		// shifting multiplicand A

	; l = 7
	; m = 0
	sbrs	r21,	7
	rjmp	p3_l_7_m_0_position_rtl_dummy

	add		r0,	r16
	eor		r8, r16
	eor		r9, r17
	eor		r10, r18
	eor		r11, r19
	eor		r12, r20
	rjmp	p3_l_7_m_1_position_rtl

p3_l_7_m_0_position_rtl_dummy:
	
	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	rjmp	p3_l_7_m_1_position_rtl

	; m = 1
p3_l_7_m_1_position_rtl:
	sbrs	r22,	7
	rjmp	p3_l_7_m_1_position_rtl_dummy

	add		r0,	r16
	eor		r9, r16
	eor		r10, r17
	eor		r11, r18
	eor		r12, r19
	eor		r13, r20
	rjmp	p3_l_7_m_2_position_rtl

p3_l_7_m_1_position_rtl_dummy:
	
	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	rjmp	p3_l_7_m_2_position_rtl

	; m = 2
p3_l_7_m_2_position_rtl:
	sbrs	r23,	7
	rjmp	p3_l_7_m_2_position_rtl_dummy

	add		r0,	r16
	eor		r10, r16
	eor		r11, r17
	eor		r12, r18
	eor		r13, r19
	eor		r14, r20
	rjmp	p3_l_7_m_3_position_rtl

p3_l_7_m_2_position_rtl_dummy:
	
	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	rjmp	p3_l_7_m_3_position_rtl

	; m = 3
p3_l_7_m_3_position_rtl:
	sbrs	r24,	7
	rjmp	p3_l_7_m_3_position_rtl_dummy

	add		r0,	r16
	eor		r11, r16
	eor		r12, r17
	eor		r13, r18
	eor		r14, r19
	eor		r15, r20
	rjmp	p3_l_7_m_3_position_rtl_end

p3_l_7_m_3_position_rtl_dummy:
	
	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	rjmp	p3_l_7_m_3_position_rtl_end

p3_l_7_m_3_position_rtl_end:

	;subi	r26,	0x0c
	subi	r26,	0x04
	sbci	r27,	0x00

	movw	r28,	r26		; to do eor with values in accumulator

	ld		r0,	Y+
	eor		r8,	r0
	st		X+,	r8

	ld		r0,	Y+
	eor		r9, r0
	st		X+,	r9

	ld		r0,	Y+
	eor		r10, r0
	st		X+,	r10

	ld		r0,	Y+
	eor		r11, r0
	st		X+,	r11

	ld		r0,	Y+
	eor		r12, r0
	st		X+,	r12

	ld		r0,	Y+
	eor		r13, r0
	st		X+,	r13

	ld		r0, Y+
	eor		r14, r0
	st		X+,	r14

	ld		r0, Y+
	eor		r15, r0
	st		X+,	r15

	regRetrieve
	ret