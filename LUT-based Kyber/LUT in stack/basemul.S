
/*
 * basemul.S
 *
 * Created: 2023-03-22 오후 2:47:57
 */ 

#include "common.i"
#include "LUT_butterfly.i"
#include "mul_asm.i"

.section .text

#define	res_mul_l		r0
#define	res_mul_h		r1
#define	zero			r2
#define	tmp0_l			r4
#define	tmp0_h			r5
#define	tmp1_l			r6
#define	tmp1_h			r7
#define res0_l			r8
#define res0_h			r9
#define res1_l			r10
#define res1_h			r11
#define	imm_tmp2		r12
#define	imm_tmp3		r13
#define	tmp_addr_l		r14
#define	tmp_addr_h		r15
#define	tmp_int			r17
#define	zeta_l			r18
#define	zeta_h			r19
#define	src0_l			r20
#define	src0_h			r21
#define	src1_l			r22
#define	src1_h			r23
#define	imm_tmp0		r24
#define	imm_tmp1		r25



.global	basemul_asm
.type	basemul_asm, @function

basemul_asm : 
	mc_prolog 0, 17

	clr		zero
	movw	r26,		r24
	movw	r28,		r22
	movw	r30,		r20

	ldd		src0_l,		Y+0
	ldd		src0_h,		Y+1
	ldd		src1_l,		Z+0
	ldd		src1_h,		Z+1

	// LUT_reduction((int32_t) a[0] * b[0]);
	movw	tmp_addr_l,	r30
	mc_muls16x16_32 src0_l, src0_h, src1_l, src1_h, imm_tmp0, imm_tmp1, imm_tmp2, imm_tmp3, zero, res_mul_l, res_mul_h
	mc_LUT_reduce_asm tmp_int, res0_l, res0_h, imm_tmp0, imm_tmp1, imm_tmp2, imm_tmp3
	movw	r30,		tmp_addr_l

	// LUT_reduction((int32_t) (a[0] - a[1]) * (b[1] - b[0]));
	ldd		tmp0_l,		Y+2
	ldd		tmp0_h,		Y+3
	ldd		tmp1_l,		Z+2
	ldd		tmp1_h,		Z+3

	sub		src0_l,		tmp0_l
	sbc		src0_h,		tmp0_h
	movw	res_mul_l,	tmp1_l
	sub		tmp1_l,		src1_l
	sbc		tmp1_h,		src1_h
	movw	src1_l,		tmp1_l
	movw	tmp1_l,		res_mul_l

	movw	tmp_addr_l,	r30
	mc_muls16x16_32 src0_l, src0_h, src1_l, src1_h, imm_tmp0, imm_tmp1, imm_tmp2, imm_tmp3, zero, res_mul_l, res_mul_h
	mc_LUT_reduce_asm tmp_int, res1_l, res1_h, imm_tmp0, imm_tmp1, imm_tmp2, imm_tmp3
	movw	r30,		tmp_addr_l

	// temp[1] += temp[0]
	add		res1_l,		res0_l
	adc		res1_h,		res0_h

	// LUT_reduction((int32_t) a[1] * b[1]);
	movw	src0_l,		tmp0_l
	movw	src1_l,		tmp1_l
	movw	tmp_addr_l,	r30
	mc_muls16x16_32 src0_l, src0_h, src1_l, src1_h, imm_tmp0, imm_tmp1, imm_tmp2, imm_tmp3, zero, res_mul_l, res_mul_h
	mc_LUT_reduce_asm tmp_int, src0_l, src0_h, imm_tmp0, imm_tmp1, imm_tmp2, imm_tmp3
	movw	r30,		tmp_addr_l

	// temp[1] += temp[0]
	add		res1_l,		src0_l
	adc		res1_h,		src0_h

	// LUT_reduction((int32_t) tmp * zeta);
	movw	tmp_addr_l,	r30
	mc_muls16x16_32 src0_l, src0_h, zeta_l, zeta_h, imm_tmp0, imm_tmp1, imm_tmp2, imm_tmp3, zero, res_mul_l, res_mul_h
	mc_LUT_reduce_asm tmp_int, src0_l, src0_h, imm_tmp0, imm_tmp1, imm_tmp2, imm_tmp3
	movw	r30,		tmp_addr_l
	add		res0_l,		src0_l
	adc		res0_h,		src0_h

	st		X+,			res0_l
	st		X+,			res0_h
	st		X+,			res1_l
	st		X+,			res1_h

	mc_epilog 0, 17
	ret


#undef	res_mul_l		
#undef	res_mul_h		
#undef	zero			
#undef	tmp0_l			
#undef	tmp0_h			
#undef	tmp1_l			
#undef	tmp1_h			
#undef	res0_l			
#undef	res0_h			
#undef	res1_l			
#undef	res1_h			
#undef	imm_tmp2		
#undef	imm_tmp3		
#undef	tmp_addr_l		
#undef	tmp_addr_h		
#undef	tmp_int			
#undef	zeta_l
#undef	zeta_h			
#undef	src0_l			
#undef	src0_h			
#undef	src1_l
#undef	src1_h
#undef	imm_tmp0
#undef	imm_tmp1