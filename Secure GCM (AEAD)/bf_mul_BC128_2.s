
/*
 * bf_mul_BC128_2.s
 *
 * Created: 2018-08-10 오전 11:16:30
 *  Author: 서석충
 * Block Comb multiplication method for 128-bit X 128-bit -> 256-bit
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
.global bf_kara_rtl_comb_128bit_ASM_Ver2

;--------------------------------------------------------------------------
; RtL Block Comb multiplication
;--------------------------------------------------------------------------

; operand ret <- r25:r24
; operand a <- r23:r22
; operand b <- r21:r20


; X(r27:r26)
; Y(r29:r28)
; Z(r31:r30)

bf_kara_rtl_comb_128bit_ASM_Ver2:
	regBackup



	regRetrieve
	ret

// EOF
