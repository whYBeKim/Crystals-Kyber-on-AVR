
/*
 * bf_mul_BC64_3.s
 *
 * Created: 2020-02-28 오전 8:45:13
 *  Author: user
 * Block Comb multiplication method for 64-bit X 64-bit -> 128-bit
 * providing constant-time execution with option 3
 * option3: multiplier encoding 방법을 적용함
 */ 

 .arch atmega128

/*.macro NOP6
	nop
	nop
	nop
	nop
	nop
	nop
.endm

.macro NOP7
	nop
	nop
	nop
	nop
	nop
	nop
	nop
.endm

.macro NOP8
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
.endm

.macro NOP9
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
.endm

 .macro	INIT_C_HIGHPART_w8						// (R8, R9, ..., R15) <- 0
	clr	r8
	clr	r9
	movw	r10,	r8
	movw	r12,	r8
	movw	r14,	r8
.endm*/

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

.macro multiplier_encoding
	clr		r30
	ldi		r31,	hi8(encoded_mul)	// address for encoded_mul

	movw	r28,	r20					// Y <- multiplier B
			
	ld		r0,		Y+					// b[0]
	ld		r1,		Y+					// b[1]
	ld		r2,		Y+					// b[2]
	ld		r3,		Y+					// b[3]
	ld		r4,		Y+					// b[4]
	ld		r5,		Y+					// b[5]
	ld		r6,		Y+					// b[6]
	ld		r7,		Y+					// b[7]

	;B[0]
	;clr		r8
	lsr		r0
	ror		r8
	lsr		r1
	ror		r8
	lsr		r2
	ror		r8
	lsr		r3
	ror		r8
	lsr		r4
	ror		r8
	lsr		r5
	ror		r8
	lsr		r6
	ror		r8
	lsr		r7
	ror		r8
	st		Z+,		r8
	
	;B[1]
	;clr		r8
	lsr		r0
	ror		r8
	lsr		r1
	ror		r8
	lsr		r2
	ror		r8
	lsr		r3
	ror		r8
	lsr		r4
	ror		r8
	lsr		r5
	ror		r8
	lsr		r6
	ror		r8
	lsr		r7
	ror		r8
	st		Z+,		r8

	;B[2]
	;clr		r8
	lsr		r0
	ror		r8
	lsr		r1
	ror		r8
	lsr		r2
	ror		r8
	lsr		r3
	ror		r8
	lsr		r4
	ror		r8
	lsr		r5
	ror		r8
	lsr		r6
	ror		r8
	lsr		r7
	ror		r8
	st		Z+,		r8

	;B[3]
	;clr		r8
	lsr		r0
	ror		r8
	lsr		r1
	ror		r8
	lsr		r2
	ror		r8
	lsr		r3
	ror		r8
	lsr		r4
	ror		r8
	lsr		r5
	ror		r8
	lsr		r6
	ror		r8
	lsr		r7
	ror		r8
	st		Z+,		r8

	;B[4]
	;clr		r8
	lsr		r0
	ror		r8
	lsr		r1
	ror		r8
	lsr		r2
	ror		r8
	lsr		r3
	ror		r8
	lsr		r4
	ror		r8
	lsr		r5
	ror		r8
	lsr		r6
	ror		r8
	lsr		r7
	ror		r8
	st		Z+,		r8

	;B[5]
	;clr		r8
	lsr		r0
	ror		r8
	lsr		r1
	ror		r8
	lsr		r2
	ror		r8
	lsr		r3
	ror		r8
	lsr		r4
	ror		r8
	lsr		r5
	ror		r8
	lsr		r6
	ror		r8
	lsr		r7
	ror		r8
	st		Z+,		r8

	;B[6]
	;clr		r8
	lsr		r0
	ror		r8
	lsr		r1
	ror		r8
	lsr		r2
	ror		r8
	lsr		r3
	ror		r8
	lsr		r4
	ror		r8
	lsr		r5
	ror		r8
	lsr		r6
	ror		r8
	lsr		r7
	ror		r8
	st		Z+,		r8

	;B[7]
	;clr		r8
	lsr		r0
	ror		r8
	lsr		r1
	ror		r8
	lsr		r2
	ror		r8
	lsr		r3
	ror		r8
	lsr		r4
	ror		r8
	lsr		r5
	ror		r8
	lsr		r6
	ror		r8
	lsr		r7
	ror		r8
	st		Z+,		r8
.endm

.macro dummy_XOR_first
	eor		r26, r16
	eor		r27, r17
	eor		r26, r18
	eor		r27, r19
	eor		r26, r20
	eor		r27, r21
	eor		r26, r22
	eor		r27, r23
.endm

.macro dummy_XOR_other
	eor		r26, r16
	eor		r27, r17
	eor		r26, r18
	eor		r27, r19
	eor		r26, r20
	eor		r27, r21
	eor		r26, r22
	eor		r27, r23
	eor		r26, r24
.endm

.macro shifting_multiplicand_w8
	lsl		r16
	rol		r17
	rol		r18
	rol		r19
	rol		r20
	rol		r21
	rol		r22
	rol		r23
	rol		r24
.endm

.data

;.org 0x0300

.byte
encoded_mul: .space 256, 0

.global intermediate_array
.byte
intermediate_array: .space 48, 0

//----------------------------------------------------------------------------//
// text part
//----------------------------------------------------------------------------//
.text
.global bf_rtl_comb_64bit_with_encoding_ASM

;--------------------------------------------------------------------------
; RtL karatsuba-block Comb multiplication unroll verision (with size 8)
; Applying multiplier encoding
;--------------------------------------------------------------------------

; operand ret <- r25:r24
; operand a <- r23:r22
; operand b <- r21:r20

; X(r27:r26)  <- ret(r25:r24)
; Y(r29:r28)  <- a (r23:r22)
; Z(r31:r30)  <- b (r21:r20)


bf_rtl_comb_64bit_with_encoding_ASM:
	regBackup

	multiplier_encoding

	// storing ret's address
	// movw	r26,	r24
	// ret의 주소정보는 스택에 push 해둠
	// 마지막에 최종결과를 저장할 때, 스택에서 pop하여 사용
	push	r24
	push	r25

	; load multiplicand A
	movw	r28,	r22
	ld		r16,	Y
	ldd		r17,	Y+1
	ldd		r18,	Y+2
	ldd		r19,	Y+3
	ldd		r20,	Y+4
	ldd		r21,	Y+5
	ldd		r22,	Y+6
	ldd		r23,	Y+7
	clr		r24

	; clear registers for accumulator
	clr		r0
	clr		r1
	movw	r2,		r0
	movw	r4,		r0
	movw	r6,		r0
	movw	r8,		r0
	movw	r10,	r0
	movw	r12,	r0
	movw	r14,	r0

	subi	r30,	0x8	;	Z <- EB

	;----------------------------------------------------------
	; l = 0
	;----------------------------------------------------------
	ld		r25,	Z+		; EB[0]

	; m = 0
	sbrs	r25,	0
	rjmp	l_0_m_0_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	eor		r5, r21
	eor		r6, r22
	eor		r7, r23
	rjmp	l_0_m_1_position_rtl_w8

l_0_m_0_position_rtl_w8_dummy:
	dummy_XOR_first
	rjmp	l_0_m_1_position_rtl_w8

	; m = 1
	l_0_m_1_position_rtl_w8:

	sbrs	r25,	1
	rjmp	l_0_m_1_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	eor		r6, r21
	eor		r7, r22
	eor		r8, r23
	rjmp	l_0_m_2_position_rtl_w8

l_0_m_1_position_rtl_w8_dummy:
	dummy_XOR_first
	rjmp	l_0_m_2_position_rtl_w8

	; m = 2
	l_0_m_2_position_rtl_w8:

	sbrs	r25,	2
	rjmp	l_0_m_2_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	eor		r7, r21
	eor		r8, r22
	eor		r9, r23
	rjmp	l_0_m_3_position_rtl_w8

l_0_m_2_position_rtl_w8_dummy:
	dummy_XOR_first
	rjmp	l_0_m_3_position_rtl_w8

	; m = 3
	l_0_m_3_position_rtl_w8:

	sbrs	r25,	3
	rjmp	l_0_m_3_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	eor		r8, r21
	eor		r9, r22
	eor		r10, r23
	rjmp	l_0_m_4_position_rtl_w8

l_0_m_3_position_rtl_w8_dummy:
	dummy_XOR_first
	rjmp	l_0_m_4_position_rtl_w8
	
	; m = 4
	l_0_m_4_position_rtl_w8:

	sbrs	r25,	4
	rjmp	l_0_m_4_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r4, r16
	eor		r5, r17
	eor		r6, r18
	eor		r7, r19
	eor		r8, r20
	eor		r9, r21
	eor		r10, r22
	eor		r11, r23
	rjmp	l_0_m_5_position_rtl_w8

l_0_m_4_position_rtl_w8_dummy:
	dummy_XOR_first
	rjmp	l_0_m_5_position_rtl_w8

	; m = 5
	l_0_m_5_position_rtl_w8:

	sbrs	r25,	5
	rjmp	l_0_m_5_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r5, r16
	eor		r6, r17
	eor		r7, r18
	eor		r8, r19
	eor		r9, r20
	eor		r10, r21
	eor		r11, r22
	eor		r12, r23
	rjmp	l_0_m_6_position_rtl_w8

l_0_m_5_position_rtl_w8_dummy:
	dummy_XOR_first
	rjmp	l_0_m_6_position_rtl_w8

	; m = 6
	l_0_m_6_position_rtl_w8:

	sbrs	r25,	6
	rjmp	l_0_m_6_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r6, r16
	eor		r7, r17
	eor		r8, r18
	eor		r9, r19
	eor		r10, r20
	eor		r11, r21
	eor		r12, r22
	eor		r13, r23
	rjmp	l_0_m_7_position_rtl_w8

l_0_m_6_position_rtl_w8_dummy:
	dummy_XOR_first
	rjmp	l_0_m_7_position_rtl_w8

	; m = 7
	l_0_m_7_position_rtl_w8:

	sbrs	r25,	7
	rjmp	l_0_m_7_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r7, r16
	eor		r8, r17
	eor		r9, r18
	eor		r10, r19
	eor		r11, r20
	eor		r12, r21
	eor		r13, r22
	eor		r14, r23
	rjmp	l_1_m_0_position_rtl_w8_start

l_0_m_7_position_rtl_w8_dummy:
	dummy_XOR_first
	rjmp	l_1_m_0_position_rtl_w8_start

l_1_m_0_position_rtl_w8_start:
	// shifting multiplicand A(r16...r24)
	shifting_multiplicand_w8

	;----------------------------------------------------------
	; l = 1
	;----------------------------------------------------------
	ld		r25,	Z+		; EB[1]

	; m = 0
	l_1_m_0_position_rtl_w8:

	sbrs	r25,	0
	rjmp	l_1_m_0_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	eor		r5, r21
	eor		r6, r22
	eor		r7, r23
	eor		r8, r24
	rjmp	l_1_m_1_position_rtl_w8

l_1_m_0_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_1_m_1_position_rtl_w8

	; m = 1
	l_1_m_1_position_rtl_w8:

	sbrs	r25,	1
	rjmp	l_1_m_1_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	eor		r6, r21
	eor		r7, r22
	eor		r8, r23
	eor		r9, r24
	rjmp	l_1_m_2_position_rtl_w8

l_1_m_1_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_1_m_2_position_rtl_w8

	; m = 2
	l_1_m_2_position_rtl_w8:

	sbrs	r25,	2
	rjmp	l_1_m_2_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	eor		r7, r21
	eor		r8, r22
	eor		r9, r23
	eor		r10, r24
	rjmp	l_1_m_3_position_rtl_w8

l_1_m_2_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_1_m_3_position_rtl_w8

	; m = 3
	l_1_m_3_position_rtl_w8:

	sbrs	r25,	3
	rjmp	l_1_m_3_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	eor		r8, r21
	eor		r9, r22
	eor		r10, r23
	eor		r11, r24
	rjmp	l_1_m_4_position_rtl_w8

l_1_m_3_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_1_m_4_position_rtl_w8

	; m = 4
	l_1_m_4_position_rtl_w8:

	sbrs	r25,	4
	rjmp	l_1_m_4_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r4, r16
	eor		r5, r17
	eor		r6, r18
	eor		r7, r19
	eor		r8, r20
	eor		r9, r21
	eor		r10, r22
	eor		r11, r23
	eor		r12, r24
	rjmp	l_1_m_5_position_rtl_w8

l_1_m_4_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_1_m_5_position_rtl_w8

	; m = 5
	l_1_m_5_position_rtl_w8:

	sbrs	r25,	5
	rjmp	l_1_m_5_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r5, r16
	eor		r6, r17
	eor		r7, r18
	eor		r8, r19
	eor		r9, r20
	eor		r10, r21
	eor		r11, r22
	eor		r12, r23
	eor		r13, r24
	rjmp	l_1_m_6_position_rtl_w8

l_1_m_5_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_1_m_6_position_rtl_w8

	; m = 6
	l_1_m_6_position_rtl_w8:

	sbrs	r25,	6
	rjmp	l_1_m_6_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r6, r16
	eor		r7, r17
	eor		r8, r18
	eor		r9, r19
	eor		r10, r20
	eor		r11, r21
	eor		r12, r22
	eor		r13, r23
	eor		r14, r24
	rjmp	l_1_m_7_position_rtl_w8

l_1_m_6_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_1_m_7_position_rtl_w8

	; m = 7
	l_1_m_7_position_rtl_w8:

	sbrs	r25,	7
	rjmp	l_1_m_7_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r7, r16
	eor		r8, r17
	eor		r9, r18
	eor		r10, r19
	eor		r11, r20
	eor		r12, r21
	eor		r13, r22
	eor		r14, r23
	eor		r15, r24
	rjmp	l_2_m_0_position_rtl_w8_start

l_1_m_7_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_2_m_0_position_rtl_w8_start

l_2_m_0_position_rtl_w8_start:
	// shifting multiplicand A(r16...r24)
	shifting_multiplicand_w8

	;----------------------------------------------------------
	; l = 2
	;----------------------------------------------------------
	ld		r25,	Z+		; EB[2]

	; m = 0
	l_2_m_0_position_rtl_w8:

	sbrs	r25,	0
	rjmp	l_2_m_0_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	eor		r5, r21
	eor		r6, r22
	eor		r7, r23
	eor		r8, r24
	rjmp	l_2_m_1_position_rtl_w8

l_2_m_0_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_2_m_1_position_rtl_w8

	; m = 1
	l_2_m_1_position_rtl_w8:

	sbrs	r25,	1
	rjmp	l_2_m_1_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	eor		r6, r21
	eor		r7, r22
	eor		r8, r23
	eor		r9, r24
	rjmp	l_2_m_2_position_rtl_w8

l_2_m_1_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_2_m_2_position_rtl_w8

	; m = 2
	l_2_m_2_position_rtl_w8:

	sbrs	r25,	2
	rjmp	l_2_m_2_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	eor		r7, r21
	eor		r8, r22
	eor		r9, r23
	eor		r10, r24
	rjmp	l_2_m_3_position_rtl_w8

l_2_m_2_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_2_m_3_position_rtl_w8

	; m = 3
	l_2_m_3_position_rtl_w8:

	sbrs	r25,	3
	rjmp	l_2_m_3_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	eor		r8, r21
	eor		r9, r22
	eor		r10, r23
	eor		r11, r24
	rjmp	l_2_m_4_position_rtl_w8

l_2_m_3_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_2_m_4_position_rtl_w8

	; m = 4
	l_2_m_4_position_rtl_w8:

	sbrs	r25,	4
	rjmp	l_2_m_4_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r4, r16
	eor		r5, r17
	eor		r6, r18
	eor		r7, r19
	eor		r8, r20
	eor		r9, r21
	eor		r10, r22
	eor		r11, r23
	eor		r12, r24
	rjmp	l_2_m_5_position_rtl_w8

l_2_m_4_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_2_m_5_position_rtl_w8

	; m = 5
	l_2_m_5_position_rtl_w8:

	sbrs	r25,	5
	rjmp	l_2_m_5_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r5, r16
	eor		r6, r17
	eor		r7, r18
	eor		r8, r19
	eor		r9, r20
	eor		r10, r21
	eor		r11, r22
	eor		r12, r23
	eor		r13, r24
	rjmp	l_2_m_6_position_rtl_w8

l_2_m_5_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_2_m_6_position_rtl_w8

	; m = 6
	l_2_m_6_position_rtl_w8:

	sbrs	r25,	6
	rjmp	l_2_m_6_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r6, r16
	eor		r7, r17
	eor		r8, r18
	eor		r9, r19
	eor		r10, r20
	eor		r11, r21
	eor		r12, r22
	eor		r13, r23
	eor		r14, r24
	rjmp	l_2_m_7_position_rtl_w8

l_2_m_6_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_2_m_7_position_rtl_w8

	; m = 7
	l_2_m_7_position_rtl_w8:

	sbrs	r25,	7
	rjmp	l_2_m_7_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r7, r16
	eor		r8, r17
	eor		r9, r18
	eor		r10, r19
	eor		r11, r20
	eor		r12, r21
	eor		r13, r22
	eor		r14, r23
	eor		r15, r24
	rjmp	l_3_m_0_position_rtl_w8_start

l_2_m_7_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_3_m_0_position_rtl_w8_start
	
l_3_m_0_position_rtl_w8_start:
	// shifting multiplicand A(r16...r24)
	shifting_multiplicand_w8

	;----------------------------------------------------------
	; l = 3
	;----------------------------------------------------------
		ld		r25,	Z+		; EB[3]

	; m = 0
	l_3_m_0_position_rtl_w8:

	sbrs	r25,	0
	rjmp	l_3_m_0_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	eor		r5, r21
	eor		r6, r22
	eor		r7, r23
	eor		r8, r24
	rjmp	l_3_m_1_position_rtl_w8

l_3_m_0_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_3_m_1_position_rtl_w8

	; m = 1
	l_3_m_1_position_rtl_w8:

	sbrs	r25,	1
	rjmp	l_3_m_1_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	eor		r6, r21
	eor		r7, r22
	eor		r8, r23
	eor		r9, r24
	rjmp	l_3_m_2_position_rtl_w8

l_3_m_1_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_3_m_2_position_rtl_w8

	; m = 2
	l_3_m_2_position_rtl_w8:

	sbrs	r25,	2
	rjmp	l_3_m_2_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	eor		r7, r21
	eor		r8, r22
	eor		r9, r23
	eor		r10, r24
	rjmp	l_3_m_3_position_rtl_w8

l_3_m_2_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_3_m_3_position_rtl_w8

	; m = 3
	l_3_m_3_position_rtl_w8:

	sbrs	r25,	3
	rjmp	l_3_m_3_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	eor		r8, r21
	eor		r9, r22
	eor		r10, r23
	eor		r11, r24
	rjmp	l_3_m_4_position_rtl_w8

l_3_m_3_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_3_m_4_position_rtl_w8

	; m = 4
	l_3_m_4_position_rtl_w8:

	sbrs	r25,	4
	rjmp	l_3_m_4_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r4, r16
	eor		r5, r17
	eor		r6, r18
	eor		r7, r19
	eor		r8, r20
	eor		r9, r21
	eor		r10, r22
	eor		r11, r23
	eor		r12, r24
	rjmp	l_3_m_5_position_rtl_w8

l_3_m_4_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_3_m_5_position_rtl_w8

	; m = 5
	l_3_m_5_position_rtl_w8:

	sbrs	r25,	5
	rjmp	l_3_m_5_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r5, r16
	eor		r6, r17
	eor		r7, r18
	eor		r8, r19
	eor		r9, r20
	eor		r10, r21
	eor		r11, r22
	eor		r12, r23
	eor		r13, r24
	rjmp	l_3_m_6_position_rtl_w8

l_3_m_5_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_3_m_6_position_rtl_w8

	; m = 6
	l_3_m_6_position_rtl_w8:

	sbrs	r25,	6
	rjmp	l_3_m_6_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r6, r16
	eor		r7, r17
	eor		r8, r18
	eor		r9, r19
	eor		r10, r20
	eor		r11, r21
	eor		r12, r22
	eor		r13, r23
	eor		r14, r24
	rjmp	l_3_m_7_position_rtl_w8

l_3_m_6_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_3_m_7_position_rtl_w8

	; m = 7
	l_3_m_7_position_rtl_w8:

	sbrs	r25,	7
	rjmp	l_3_m_7_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r7, r16
	eor		r8, r17
	eor		r9, r18
	eor		r10, r19
	eor		r11, r20
	eor		r12, r21
	eor		r13, r22
	eor		r14, r23
	eor		r15, r24
	rjmp	l_4_m_0_position_rtl_w8_start

l_3_m_7_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_4_m_0_position_rtl_w8_start
	
l_4_m_0_position_rtl_w8_start:
	// shifting multiplicand A(r16...r24)
	shifting_multiplicand_w8

	;----------------------------------------------------------
	; l = 4
	;----------------------------------------------------------
	ld		r25,	Z+		; EB[4]

	; m = 0
	l_4_m_0_position_rtl_w8:

	sbrs	r25,	0
	rjmp	l_4_m_0_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	eor		r5, r21
	eor		r6, r22
	eor		r7, r23
	eor		r8, r24
	rjmp	l_4_m_1_position_rtl_w8

l_4_m_0_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_4_m_1_position_rtl_w8

	; m = 1
	l_4_m_1_position_rtl_w8:

	sbrs	r25,	1
	rjmp	l_4_m_1_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	eor		r6, r21
	eor		r7, r22
	eor		r8, r23
	eor		r9, r24
	rjmp	l_4_m_2_position_rtl_w8

l_4_m_1_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_4_m_2_position_rtl_w8

	; m = 2
	l_4_m_2_position_rtl_w8:

	sbrs	r25,	2
	rjmp	l_4_m_2_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	eor		r7, r21
	eor		r8, r22
	eor		r9, r23
	eor		r10, r24
	rjmp	l_4_m_3_position_rtl_w8

l_4_m_2_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_4_m_3_position_rtl_w8

	; m = 3
	l_4_m_3_position_rtl_w8:

	sbrs	r25,	3
	rjmp	l_4_m_3_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	eor		r8, r21
	eor		r9, r22
	eor		r10, r23
	eor		r11, r24
	rjmp	l_4_m_4_position_rtl_w8

l_4_m_3_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_4_m_4_position_rtl_w8

	; m = 4
	l_4_m_4_position_rtl_w8:

	sbrs	r25,	4
	rjmp	l_4_m_4_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r4, r16
	eor		r5, r17
	eor		r6, r18
	eor		r7, r19
	eor		r8, r20
	eor		r9, r21
	eor		r10, r22
	eor		r11, r23
	eor		r12, r24
	rjmp	l_4_m_5_position_rtl_w8

l_4_m_4_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_4_m_5_position_rtl_w8

	; m = 5
	l_4_m_5_position_rtl_w8:

	sbrs	r25,	5
	rjmp	l_4_m_5_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r5, r16
	eor		r6, r17
	eor		r7, r18
	eor		r8, r19
	eor		r9, r20
	eor		r10, r21
	eor		r11, r22
	eor		r12, r23
	eor		r13, r24
	rjmp	l_4_m_6_position_rtl_w8

l_4_m_5_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_4_m_6_position_rtl_w8

	; m = 6
	l_4_m_6_position_rtl_w8:

	sbrs	r25,	6
	rjmp	l_4_m_6_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r6, r16
	eor		r7, r17
	eor		r8, r18
	eor		r9, r19
	eor		r10, r20
	eor		r11, r21
	eor		r12, r22
	eor		r13, r23
	eor		r14, r24
	rjmp	l_4_m_7_position_rtl_w8

l_4_m_6_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_4_m_7_position_rtl_w8

	; m = 7
	l_4_m_7_position_rtl_w8:

	sbrs	r25,	7
	rjmp	l_4_m_7_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r7, r16
	eor		r8, r17
	eor		r9, r18
	eor		r10, r19
	eor		r11, r20
	eor		r12, r21
	eor		r13, r22
	eor		r14, r23
	eor		r15, r24
	rjmp	l_5_m_0_position_rtl_w8_start

l_4_m_7_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_5_m_0_position_rtl_w8_start
	
l_5_m_0_position_rtl_w8_start:
	// shifting multiplicand A(r16...r24)
	shifting_multiplicand_w8

	;----------------------------------------------------------
	; l = 5
	;----------------------------------------------------------
	ld		r25,	Z+		; EB[5]

	; m = 0
	l_5_m_0_position_rtl_w8:

	sbrs	r25,	0
	rjmp	l_5_m_0_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	eor		r5, r21
	eor		r6, r22
	eor		r7, r23
	eor		r8, r24
	rjmp	l_5_m_1_position_rtl_w8

l_5_m_0_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_5_m_1_position_rtl_w8

	; m = 1
	l_5_m_1_position_rtl_w8:

	sbrs	r25,	1
	rjmp	l_5_m_1_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	eor		r6, r21
	eor		r7, r22
	eor		r8, r23
	eor		r9, r24
	rjmp	l_5_m_2_position_rtl_w8

l_5_m_1_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_5_m_2_position_rtl_w8

	; m = 2
	l_5_m_2_position_rtl_w8:

	sbrs	r25,	2
	rjmp	l_5_m_2_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	eor		r7, r21
	eor		r8, r22
	eor		r9, r23
	eor		r10, r24
	rjmp	l_5_m_3_position_rtl_w8

l_5_m_2_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_5_m_3_position_rtl_w8

	; m = 3
	l_5_m_3_position_rtl_w8:

	sbrs	r25,	3
	rjmp	l_5_m_3_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	eor		r8, r21
	eor		r9, r22
	eor		r10, r23
	eor		r11, r24
	rjmp	l_5_m_4_position_rtl_w8

l_5_m_3_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_5_m_4_position_rtl_w8

	; m = 4
	l_5_m_4_position_rtl_w8:

	sbrs	r25,	4
	rjmp	l_5_m_4_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r4, r16
	eor		r5, r17
	eor		r6, r18
	eor		r7, r19
	eor		r8, r20
	eor		r9, r21
	eor		r10, r22
	eor		r11, r23
	eor		r12, r24
	rjmp	l_5_m_5_position_rtl_w8

l_5_m_4_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_5_m_5_position_rtl_w8

	; m = 5
	l_5_m_5_position_rtl_w8:

	sbrs	r25,	5
	rjmp	l_5_m_5_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r5, r16
	eor		r6, r17
	eor		r7, r18
	eor		r8, r19
	eor		r9, r20
	eor		r10, r21
	eor		r11, r22
	eor		r12, r23
	eor		r13, r24
	rjmp	l_5_m_6_position_rtl_w8

l_5_m_5_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_5_m_6_position_rtl_w8

	; m = 6
	l_5_m_6_position_rtl_w8:

	sbrs	r25,	6
	rjmp	l_5_m_6_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r6, r16
	eor		r7, r17
	eor		r8, r18
	eor		r9, r19
	eor		r10, r20
	eor		r11, r21
	eor		r12, r22
	eor		r13, r23
	eor		r14, r24
	rjmp	l_5_m_7_position_rtl_w8

l_5_m_6_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_5_m_7_position_rtl_w8

	; m = 7
	l_5_m_7_position_rtl_w8:

	sbrs	r25,	7
	rjmp	l_5_m_7_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r7, r16
	eor		r8, r17
	eor		r9, r18
	eor		r10, r19
	eor		r11, r20
	eor		r12, r21
	eor		r13, r22
	eor		r14, r23
	eor		r15, r24
	rjmp	l_6_m_0_position_rtl_w8_start

l_5_m_7_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_6_m_0_position_rtl_w8_start
	
l_6_m_0_position_rtl_w8_start:
	// shifting multiplicand A(r16...r24)
	shifting_multiplicand_w8

	;----------------------------------------------------------
	; l = 6
	;----------------------------------------------------------
	ld		r25,	Z+		; EB[6]

	; m = 0
	l_6_m_0_position_rtl_w8:

	sbrs	r25,	0
	rjmp	l_6_m_0_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	eor		r5, r21
	eor		r6, r22
	eor		r7, r23
	eor		r8, r24
	rjmp	l_6_m_1_position_rtl_w8

l_6_m_0_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_6_m_1_position_rtl_w8

	; m = 1
	l_6_m_1_position_rtl_w8:

	sbrs	r25,	1
	rjmp	l_6_m_1_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	eor		r6, r21
	eor		r7, r22
	eor		r8, r23
	eor		r9, r24
	rjmp	l_6_m_2_position_rtl_w8

l_6_m_1_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_6_m_2_position_rtl_w8

	; m = 2
	l_6_m_2_position_rtl_w8:

	sbrs	r25,	2
	rjmp	l_6_m_2_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	eor		r7, r21
	eor		r8, r22
	eor		r9, r23
	eor		r10, r24
	rjmp	l_6_m_3_position_rtl_w8

l_6_m_2_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_6_m_3_position_rtl_w8

	; m = 3
	l_6_m_3_position_rtl_w8:

	sbrs	r25,	3
	rjmp	l_6_m_3_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	eor		r8, r21
	eor		r9, r22
	eor		r10, r23
	eor		r11, r24
	rjmp	l_6_m_4_position_rtl_w8

l_6_m_3_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_6_m_4_position_rtl_w8

	; m = 4
	l_6_m_4_position_rtl_w8:

	sbrs	r25,	4
	rjmp	l_6_m_4_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r4, r16
	eor		r5, r17
	eor		r6, r18
	eor		r7, r19
	eor		r8, r20
	eor		r9, r21
	eor		r10, r22
	eor		r11, r23
	eor		r12, r24
	rjmp	l_6_m_5_position_rtl_w8

l_6_m_4_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_6_m_5_position_rtl_w8

	; m = 5
	l_6_m_5_position_rtl_w8:

	sbrs	r25,	5
	rjmp	l_6_m_5_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r5, r16
	eor		r6, r17
	eor		r7, r18
	eor		r8, r19
	eor		r9, r20
	eor		r10, r21
	eor		r11, r22
	eor		r12, r23
	eor		r13, r24
	rjmp	l_6_m_6_position_rtl_w8

l_6_m_5_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_6_m_6_position_rtl_w8

	; m = 6
	l_6_m_6_position_rtl_w8:

	sbrs	r25,	6
	rjmp	l_6_m_6_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r6, r16
	eor		r7, r17
	eor		r8, r18
	eor		r9, r19
	eor		r10, r20
	eor		r11, r21
	eor		r12, r22
	eor		r13, r23
	eor		r14, r24
	rjmp	l_6_m_7_position_rtl_w8

l_6_m_6_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_6_m_7_position_rtl_w8

	; m = 7
	l_6_m_7_position_rtl_w8:

	sbrs	r25,	7
	rjmp	l_6_m_7_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r7, r16
	eor		r8, r17
	eor		r9, r18
	eor		r10, r19
	eor		r11, r20
	eor		r12, r21
	eor		r13, r22
	eor		r14, r23
	eor		r15, r24
	rjmp	l_7_m_0_position_rtl_w8_start

l_6_m_7_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_7_m_0_position_rtl_w8_start
	
l_7_m_0_position_rtl_w8_start:
	// shifting multiplicand A(r16...r24)
	shifting_multiplicand_w8

	;----------------------------------------------------------
	; l = 7
	;----------------------------------------------------------
	ld		r25,	Z+		; EB[7]

	; m = 0
	l_7_m_0_position_rtl_w8:

	sbrs	r25,	0
	rjmp	l_7_m_0_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r0, r16
	eor		r1, r17
	eor		r2, r18
	eor		r3, r19
	eor		r4, r20
	eor		r5, r21
	eor		r6, r22
	eor		r7, r23
	eor		r8, r24
	rjmp	l_7_m_1_position_rtl_w8

l_7_m_0_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_7_m_1_position_rtl_w8

	; m = 1
	l_7_m_1_position_rtl_w8:

	sbrs	r25,	1
	rjmp	l_7_m_1_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r1, r16
	eor		r2, r17
	eor		r3, r18
	eor		r4, r19
	eor		r5, r20
	eor		r6, r21
	eor		r7, r22
	eor		r8, r23
	eor		r9, r24
	rjmp	l_7_m_2_position_rtl_w8

l_7_m_1_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_7_m_2_position_rtl_w8

	; m = 2
	l_7_m_2_position_rtl_w8:

	sbrs	r25,	2
	rjmp	l_7_m_2_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r2, r16
	eor		r3, r17
	eor		r4, r18
	eor		r5, r19
	eor		r6, r20
	eor		r7, r21
	eor		r8, r22
	eor		r9, r23
	eor		r10, r24
	rjmp	l_7_m_3_position_rtl_w8

l_7_m_2_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_7_m_3_position_rtl_w8

	; m = 3
	l_7_m_3_position_rtl_w8:

	sbrs	r25,	3
	rjmp	l_7_m_3_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r3, r16
	eor		r4, r17
	eor		r5, r18
	eor		r6, r19
	eor		r7, r20
	eor		r8, r21
	eor		r9, r22
	eor		r10, r23
	eor		r11, r24
	rjmp	l_7_m_4_position_rtl_w8

l_7_m_3_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_7_m_4_position_rtl_w8

	; m = 4
	l_7_m_4_position_rtl_w8:

	sbrs	r25,	4
	rjmp	l_7_m_4_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r4, r16
	eor		r5, r17
	eor		r6, r18
	eor		r7, r19
	eor		r8, r20
	eor		r9, r21
	eor		r10, r22
	eor		r11, r23
	eor		r12, r24
	rjmp	l_7_m_5_position_rtl_w8

l_7_m_4_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_7_m_5_position_rtl_w8

	; m = 5
	l_7_m_5_position_rtl_w8:

	sbrs	r25,	5
	rjmp	l_7_m_5_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r5, r16
	eor		r6, r17
	eor		r7, r18
	eor		r8, r19
	eor		r9, r20
	eor		r10, r21
	eor		r11, r22
	eor		r12, r23
	eor		r13, r24
	rjmp	l_7_m_6_position_rtl_w8

l_7_m_5_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_7_m_6_position_rtl_w8

	; m = 6
	l_7_m_6_position_rtl_w8:

	sbrs	r25,	6
	rjmp	l_7_m_6_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r6, r16
	eor		r7, r17
	eor		r8, r18
	eor		r9, r19
	eor		r10, r20
	eor		r11, r21
	eor		r12, r22
	eor		r13, r23
	eor		r14, r24
	rjmp	l_7_m_7_position_rtl_w8

l_7_m_6_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_7_m_7_position_rtl_w8

	; m = 7
	l_7_m_7_position_rtl_w8:

	sbrs	r25,	7
	rjmp	l_7_m_7_position_rtl_w8_dummy
	
	add		r26,	r16

	eor		r7, r16
	eor		r8, r17
	eor		r9, r18
	eor		r10, r19
	eor		r11, r20
	eor		r12, r21
	eor		r13, r22
	eor		r14, r23
	eor		r15, r24
	rjmp	l_7_m_0_position_rtl_w8_end

l_7_m_7_position_rtl_w8_dummy:
	dummy_XOR_other
	rjmp	l_7_m_0_position_rtl_w8_end
	
l_7_m_0_position_rtl_w8_end:

	// ret 주소값 복원
	pop		r29
	pop		r28
	st		Y,		r0
	std		Y+1,		r1
	std		Y+2,		r2
	std		Y+3,		r3
	std		Y+4,		r4
	std		Y+5,		r5
	std		Y+6,		r6
	std		Y+7,		r7
	std		Y+8,		r8
	std		Y+9,		r9
	std		Y+10,		r10
	std		Y+11,		r11
	std		Y+12,		r12
	std		Y+13,		r13
	std		Y+14,		r14
	std		Y+15,		r15

	regRetrieve

	ret


