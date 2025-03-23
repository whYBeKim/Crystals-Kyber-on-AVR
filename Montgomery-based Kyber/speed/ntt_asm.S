
/*
 * ntt_asm.S
 *
 * Created: 2022-10-14 오전 2:01:30
 *  Author: youngbeom
 */ 

 #include "common.i"
 #include "mul_asm.i"

.section .data

.equ Q_asm, 3329
.equ Qinv_asm, -3327

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
	ld	df_zetas0, X+
	ld	df_zetas1, X+

1: 
	mc_butterfly	df_a0, df_a1, df_b0, df_b1, df_zetas0, df_zetas1, df_c0, df_c1, df_c2, df_c3, df_carry, df_fixed_r0, df_fixed_r1, df_res_mont0, df_res_mont1, df_tmp0, df_tmp1, df_tmp2, df_tmp3, df_Qinv0, df_Qinv1, df_Q0, df_Q1

	dec	df_cnt_in
	brne	1b

	mov	df_cnt_in, df_cnt_tmp

	ldi	r16, \const_offset
	add	r28, r16
	adc	r29, df_carry
	add	r30, r16
	adc	r31, df_carry

	dec	df_cnt_out
	brne	0b

.endm



.global	ntt_asm
.type	ntt_asm, @function

ntt_asm : 
	mc_prolog 0, 17

	movw	r28, df_src_adr0 
	movw	r30, df_src_adr0
	
	ldi	r16, lo8(Qinv_asm)
	ldi	r17, hi8(Qinv_asm)
	movw	df_Qinv0, r16
	ldi	df_Q0, lo8(Q_asm)
	ldi	df_Q1, hi8(Q_asm)
	ldi	df_zetas_adr0, lo8(zetas)
	ldi	df_zetas_adr1, hi8(zetas)
	inc	df_zetas_adr0
	inc	df_zetas_adr0
	
	clr df_carry

layer0:

	inc	r31
	ldi	r16, 128
	mov	df_cnt_out, r16

	ld	df_zetas0, X+
	ld	df_zetas1, X+

00: 
	mc_butterfly	df_a0, df_a1, df_b0, df_b1, df_zetas0, df_zetas1, df_c0, df_c1, df_c2, df_c3, df_carry, df_fixed_r0, df_fixed_r1, df_res_mont0, df_res_mont1, df_tmp0, df_tmp1, df_tmp2, df_tmp3, df_Qinv0, df_Qinv1, df_Q0, df_Q1
	dec	df_cnt_out
	brne	00b

layer1:

	ldi	r16, 64
	mov	df_cnt_in, r16
	mov	df_cnt_tmp, df_cnt_in

	movw	r28, df_src_adr0 
	movw	r30, df_src_adr0
	ldi	r16, 128
	add	r30, r16
	adc	r31, df_carry

	ld	df_zetas0, X+
	ld	df_zetas1, X+

10: 
	mc_butterfly	df_a0, df_a1, df_b0, df_b1, df_zetas0, df_zetas1, df_c0, df_c1, df_c2, df_c3, df_carry, df_fixed_r0, df_fixed_r1, df_res_mont0, df_res_mont1, df_tmp0, df_tmp1, df_tmp2, df_tmp3, df_Qinv0, df_Qinv1, df_Q0, df_Q1

	dec	df_cnt_in
	brne	10b

	mov	df_cnt_in, df_cnt_tmp

	movw	r28, df_src_adr0 
	movw	r30, df_src_adr0
	inc	r29
	inc	r31
	ldi	r16, 128
	add	r30, r16
	adc	r31, df_carry

	ld	df_zetas0, X+
	ld	df_zetas1, X+

11: 
	mc_butterfly	df_a0, df_a1, df_b0, df_b1, df_zetas0, df_zetas1, df_c0, df_c1, df_c2, df_c3, df_carry, df_fixed_r0, df_fixed_r1, df_res_mont0, df_res_mont1, df_tmp0, df_tmp1, df_tmp2, df_tmp3, df_Qinv0, df_Qinv1, df_Q0, df_Q1

	dec	df_cnt_in
	brne	11b

	//layer 2
	layer	32,	4,	64
	
	//layer 3
	layer	16,	8,	32

	//layer 4
	layer	8,	16,	16

	//layer 5
	layer	4,	32,	8

	//layer 6
	layer	2,	64,	4

end:
	mc_epilog 0, 17
	ret