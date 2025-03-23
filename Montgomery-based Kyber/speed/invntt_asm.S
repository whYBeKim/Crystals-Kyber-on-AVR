
/*
 * invntt_asm.S
 *
 * Created: 2022-10-15 오전 4:32:41
 *  Author: youngbeom
 */ 
 #include "common.i"
 #include "mul_asm.i"
 
.section .data

.equ barret_asm, 0x4EBF
.equ Q_asm, 3329
.equ Qinv_asm, -3327
.equ montfactor, 1441

.section .text

#define df_fixed_r0 r0
#define df_fixed_r1 r1

#define df_carry r2
#define df_cnt_tmp r3
#define df_cnt_in r14
#define df_cnt_out r15

#define df_tmp0 r6
#define df_tmp1 r7
#define df_tmp2 r8
#define df_tmp3 r9

#define df_c0 r10
#define df_c1 r11
#define df_c2 r12
#define df_c3 r13

#define df_a0 r10
#define df_a1 r11
#define df_b0 r18
#define df_b1 r19

#define df_res_mont0 r20
#define df_res_mont1 r21
#define df_barret0 r20
#define df_barret1 r21

#define df_zetas0 r16
#define df_zetas1 r17
#define df_zetas_adr0 r26
#define df_zetas_adr1 r27

#define df_Q0 r22
#define df_Q1 r23
#define df_src_adr0 r24
#define df_src_adr1 r25
#define df_Qinv0 r4
#define df_Qinv1 r5

.macro	layer	const_in,	const_out,	const_offset

	ldi	r16, \const_in
	mov	df_cnt_in, r16
	mov	df_cnt_tmp, df_cnt_in

	ldi	r16, \const_out
	mov	df_cnt_out, r16

	movw	r28, df_src_adr0 
	movw	r30, df_src_adr0
	ldi	r16, \const_offset
	add	r30, r16
	adc	r31, df_carry

0:
	ld	df_zetas1, -X
	ld	df_zetas0, -X

1: 
	mc_inv_butterfly	df_a0, df_a1, df_b0, df_b1, df_zetas0, df_zetas1, df_c0, df_c1, df_c2, df_c3, df_carry, df_fixed_r0, df_fixed_r1, df_res_mont0, df_res_mont1, df_tmp0, df_tmp1, df_tmp2, df_tmp3, df_Qinv0, df_Qinv1, df_Q0, df_Q1, df_barret0, df_barret1

	dec	df_cnt_in
	breq	2f
	rjmp	1b

2:	
	mov	df_cnt_in, df_cnt_tmp

	ldi	r16, \const_offset
	add	r28, r16
	adc	r29, df_carry
	add	r30, r16
	adc	r31, df_carry

	dec	df_cnt_out
	breq	3f
	rjmp	0b

3:
.endm


.global	invntt_asm
.type	invntt_asm, @function

invntt_asm : 
	mc_prolog 0, 17

	movw	r28, df_src_adr0 
	movw	r30, df_src_adr0
	
	ldi	r16, lo8(Qinv_asm)
	ldi	r17, hi8(Qinv_asm)
	movw	df_Qinv0, r16

	clr df_carry
	ldi	df_zetas_adr0, lo8(zetas)
	ldi	df_zetas_adr1, hi8(zetas)
	inc	df_zetas_adr1

	//layer 6
	layer	2, 64, 4

	//layer 5
	layer	4, 32, 8

	//layer 4
	layer	8, 16, 16

	//layer 3
	layer	16, 8, 32

	//layer 2
	layer	32, 4, 64

	//layer 1
	layer	64, 2, 128

layer0 :

	movw	r28, df_src_adr0 
	movw	r30, df_src_adr0
	inc	r31

	ldi	r16, 128
	mov	df_cnt_in, r16

	ld	df_zetas1, -X
	ld	df_zetas0, -X

00:

	mc_inv_butterfly	df_a0, df_a1, df_b0, df_b1, df_zetas0, df_zetas1, df_c0, df_c1, df_c2, df_c3, df_carry, df_fixed_r0, df_fixed_r1, df_res_mont0, df_res_mont1, df_tmp0, df_tmp1, df_tmp2, df_tmp3, df_Qinv0, df_Qinv1, df_Q0, df_Q1, df_barret0, df_barret1
	dec	df_cnt_in
	breq	01f
	rjmp	00b   

01:

	movw	r28, df_src_adr0
	clr	r16
	dec	r16
	mov	df_cnt_in, r16
	ldi	df_zetas0, lo8(montfactor)
	ldi	df_zetas1, hi8(montfactor)

02:
	ldd	df_b0, Y+0
	ldd	df_b1, Y+1

	mc_muls16x16_32 	df_b0, 	df_b1, 	df_zetas0, 	df_zetas1, 	df_c0, 	df_c1, 	df_c2, 	df_c3, 	df_carry, 	df_fixed_r0, 	df_fixed_r1
	mc_montgomery_reduce df_c0, df_c1, df_c2, df_c3, df_res_mont0, df_res_mont1, df_tmp0, df_tmp1, df_tmp2, df_tmp3, df_carry, df_Qinv0, df_Qinv1, df_Q0, df_Q1, df_fixed_r0, df_fixed_r1

	st	Y+, df_res_mont0
	st	Y+, df_res_mont1
	dec	df_cnt_in
	brne	02b

end:
	
	ldd	df_b0, Y+0
	ldd	df_b1, Y+1

	mc_muls16x16_32 	df_b0, 	df_b1, 	df_zetas0, 	df_zetas1, 	df_c0, 	df_c1, 	df_c2, 	df_c3, 	df_carry, 	df_fixed_r0, 	df_fixed_r1
	mc_montgomery_reduce df_c0, df_c1, df_c2, df_c3, df_res_mont0, df_res_mont1, df_tmp0, df_tmp1, df_tmp2, df_tmp3, df_carry, df_Qinv0, df_Qinv1, df_Q0, df_Q1, df_fixed_r0, df_fixed_r1

	st	Y+, df_res_mont0
	st	Y+, df_res_mont1

	mc_epilog 0, 17
	ret
 