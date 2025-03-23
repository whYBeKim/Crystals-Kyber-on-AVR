
/*
 * bf_add.s
 *
 * Created: 2018-08-13 오전 9:48:48
 *  Author: 서석충
 */ 

//.arch atmega128

.macro regBackupAdd

	.irp i, 28, 29
		push 	\i
	.endr
	
.endm

.macro regRetrieveAdd

	clr		r1
	.irp i, 29, 28
		pop 	\i
	.endr
	ret
.endm

.macro regBackupAdd2

	.irp i, 0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 28, 29
		push 	\i
	.endr
	
.endm

.macro regRetrieveAdd2

	clr		r1
	.irp i, 29, 28, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 0
		pop 	\i
	.endr
	ret

.endm

//----------------------------------------------------------------------------//
// text part
//----------------------------------------------------------------------------//
.text
.global bf_add_128bit_with_accu_asm

; operand ret <- r25:r24
; operand a <- r23:r22
; operand b <- r21:r20
; operand c <- r19:r18

; X(r27:r26)
; Y(r29:r28)
; Z(r31:r30)

/*bf_add_128bit_with_accu_asm:

	regBackupAdd

	movw	r30,	r24
	movw	r26,	r22
	movw	r28,	r20

	// a[0]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[1]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[2]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[3]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[4]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[5]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[6]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[7]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[8]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[9]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[10]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[11]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[12]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[13]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[14]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[15]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	regRetrieveAdd
	ret*/

.global bf_add_128bit_asm

; operand ret <- r25:r24
; operand a <- r23:r22
; operand b <- r21:r20


; X(r27:r26)
; Y(r29:r28)
; Z(r31:r30)

bf_add_128bit_asm:

	regBackupAdd

	movw	r30,	r24
	movw	r26,	r22
	movw	r28,	r20

	// a[0]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[1]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[2]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[3]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[4]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[5]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[6]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[7]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[8]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[9]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[10]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[11]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[12]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[13]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[14]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[15]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	regRetrieveAdd
	ret

.global bf_add_64bit_asm

; operand ret <- r25:r24
; operand a <- r23:r22
; operand b <- r21:r20


; X(r27:r26)
; Y(r29:r28)
; Z(r31:r30)

bf_add_64bit_asm:

	regBackupAdd

	movw	r30,	r24
	movw	r26,	r22
	movw	r28,	r20

	// a[0]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[1]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[2]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[3]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[4]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[5]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[6]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	// a[7]
	ld		r18,	X+
	ld		r19,	Y+
	eor		r18,	r19
	st		Z+,		r18

	regRetrieveAdd
	ret


.global bf_add_128bit_accu_asm

; operand ret <- r25:r24
; operand a <- r23:r22


; X(r27:r26)
; Y(r29:r28)
; Z(r31:r30)

bf_add_128bit_accu_asm:

	regBackupAdd2
	
	movw	r30,	r24		; Z <- accu
	movw	r28,	r22		; Y <- intermediate_array(L||M||H, 각각 16바이트임, 주소정렬됨)
	
	adiw	r28,	8		; LH 로드
	ld		r0,		Y+
	ld		r1,		Y+
	ld		r2,		Y+
	ld		r3,		Y+
	ld		r4,		Y+
	ld		r5,		Y+
	ld		r6,		Y+
	ld		r7,		Y+

	adiw	r28,	16		; HL로드
	ld		r8,		Y+
	ld		r9,		Y+
	ld		r10,	Y+
	ld		r11,	Y+
	ld		r12,	Y+
	ld		r13,	Y+
	ld		r14,	Y+
	ld		r15,	Y+

	eor		r0,		r8		; (HL ^ LH) 계산
	eor		r1,		r9
	eor		r2,		r10
	eor		r3,		r11
	eor		r4,		r12
	eor		r5,		r13
	eor		r6,		r14
	eor		r7,		r15

	movw	r8,		r0		; (HL ^ LH) 복사
	movw	r10,	r2
	movw	r12,	r4
	movw	r14,	r6

	subi	r28,	40		; 시작주소로 되돌림(LL에 접근)
	
	ld		r17,	Y+
	st		Z+,		r17
	eor		r0,		r17

	ld		r17,	Y+
	st		Z+,		r17
	eor		r1,		r17

	ld		r17,	Y+
	st		Z+,		r17
	eor		r2,		r17

	ld		r17,	Y+
	st		Z+,		r17
	eor		r3,		r17

	ld		r17,	Y+
	st		Z+,		r17
	eor		r4,		r17

	ld		r17,	Y+
	st		Z+,		r17
	eor		r5,		r17

	ld		r17,	Y+
	st		Z+,		r17
	eor		r6,		r17

	ld		r17,	Y+
	st		Z+,		r17
	eor		r7,		r17

	adiw	r28,	8		; ML에 접근

	ld		r17,	Y+
	eor		r0,		r17

	ld		r17,	Y+
	eor		r1,		r17

	ld		r17,	Y+
	eor		r2,		r17

	ld		r17,	Y+
	eor		r3,		r17

	ld		r17,	Y+
	eor		r4,		r17

	ld		r17,	Y+
	eor		r5,		r17

	ld		r17,	Y+
	eor		r6,		r17

	ld		r17,	Y+
	eor		r7,		r17

	ld		r17,	Y+
	eor		r8,		r17

	ld		r17,	Y+
	eor		r9,		r17

	ld		r17,	Y+
	eor		r10,	r17

	ld		r17,	Y+
	eor		r11,	r17

	ld		r17,	Y+
	eor		r12,	r17

	ld		r17,	Y+
	eor		r13,	r17

	ld		r17,	Y+
	eor		r14,	r17

	ld		r17,	Y+
	eor		r15,	r17

	st		Z+,		r0
	st		Z+,		r1
	st		Z+,		r2
	st		Z+,		r3
	st		Z+,		r4
	st		Z+,		r5
	st		Z+,		r6
	st		Z+,		r7

	adiw	r28,	8		; HH에 접근

	ld		r17,	Y+
	eor		r8,		r17
	std		Z+8,	r17
	st		Z+,		r8
	
	ld		r17,	Y+
	eor		r9,		r17
	std		Z+8,	r17
	st		Z+,		r9

	ld		r17,	Y+
	eor		r10,	r17
	std		Z+8,	r17
	st		Z+,		r10
	
	ld		r17,	Y+
	eor		r11,	r17
	std		Z+8,	r17
	st		Z+,		r11

	ld		r17,	Y+
	eor		r12,	r17
	std		Z+8,	r17
	st		Z+,		r12

	ld		r17,	Y+
	eor		r13,	r17
	std		Z+8,	r17
	st		Z+,		r13

	ld		r17,	Y+
	eor		r14,	r17
	std		Z+8,	r17
	st		Z+,		r14

	ld		r17,	Y+
	eor		r15,	r17
	std		Z+8,	r17
	st		Z+,		r15

	regRetrieveAdd2
	ret
	