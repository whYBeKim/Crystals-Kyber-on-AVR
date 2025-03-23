
/*
 * LUT_butterfly.i
 *
 * Created: 2023-03-19 오후 4:46:06
 */ 

.macro mc_small_LUT_reduce_asm zero, src_l, src_h, t_l

	mov		r30,		\src_h	
	ldi		r31,		hi8(LUT3_H)
	ld		\src_h,		Z
	ldi		r31,		hi8(LUT3_L)
	ld		\t_l,		Z
	add		\src_l,		\t_l
	adc		\src_h,		\zero	
		
.endm

.macro mc_LUT_reduce_asm tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh

	mov		r30,			\tmp_hh
	andi	r30,			0x0F
	mov		\tmp_integer,	\tmp_lh
	andi	\tmp_integer,	0xF0
	eor		r30,			\tmp_integer

	andi	\tmp_lh,		0x0F
	ldi		r31,			hi8(LUT2_H)
	ld		\res_h,			Z
	ldi		r31,			hi8(LUT2_L)
	ld		\res_l,			Z
	add		\res_l,			\tmp_ll
	adc		\res_h,			\tmp_lh 
	
	mov		r30,			\tmp_hl
	ldi		r31,			hi8(LUT1_H)
	ld		\tmp_hh,			Z
	ldi		r31,			hi8(LUT1_L)
	ld		\tmp_hl,			Z
	add		\res_l,			\tmp_hl
	adc		\res_h,			\tmp_hh
		
.endm


.macro mc_LUT_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	ld		\coeffs1_l,		X+
	ld		\coeffs1_h,		X
	ldd		\coeffs2_l,		Y+0
	ldd		\coeffs2_h,		Y+1
	
	mc_mulsu16x16_32	\coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h
	mc_LUT_reduce_asm	\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh

	movw	\coeffs2_l,		\coeffs1_l
	add		\coeffs1_l,		\res_l
	adc		\coeffs1_h,		\res_h
	sub		\coeffs2_l,		\res_l
	sbc		\coeffs2_h,		\res_h

	dec		r26
	st		X+,				\coeffs1_l
	st		X+,				\coeffs1_h
	st		Y+,				\coeffs2_l
	st		Y+,				\coeffs2_h
.endm

.macro mc_LUT_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								 tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	ld		\coeffs2_l,		X+
	ld		\coeffs2_h,		X
	ldd		\coeffs1_l,		Y+0
	ldd		\coeffs1_h,		Y+1
	
	mc_mulsu16x16_32	\coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h
	mc_LUT_reduce_asm	\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh

	movw	\coeffs2_l,		\coeffs1_l
	add		\coeffs1_l,		\res_l
	adc		\coeffs1_h,		\res_h
	sub		\coeffs2_l,		\res_l
	sbc		\coeffs2_h,		\res_h

	dec		r26
	st		X+,				\coeffs2_l
	st		X+,				\coeffs2_h
	st		Y+,				\coeffs1_l
	st		Y+,				\coeffs1_h
.endm


.macro mc_ssLUT_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	ld		\coeffs1_l,		X+
	ld		\coeffs1_h,		X
	ldd		\coeffs2_l,		Y+0
	ldd		\coeffs2_h,		Y+1
	
	mc_mulsu16x16_32	\coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h
	mc_LUT_reduce_asm	\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh
	mc_small_LUT_reduce_asm	\zero, \coeffs1_l, \coeffs1_h, \tmp_integer

	movw	\coeffs2_l,		\coeffs1_l
	add		\coeffs1_l,		\res_l
	adc		\coeffs1_h,		\res_h
	sub		\coeffs2_l,		\res_l
	sbc		\coeffs2_h,		\res_h

	dec		r26
	st		X+,				\coeffs1_l
	st		X+,				\coeffs1_h
	st		Y+,				\coeffs2_l
	st		Y+,				\coeffs2_h
.endm

.macro mc_ssLUT_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								 tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	ld		\coeffs2_l,		X+
	ld		\coeffs2_h,		X
	ldd		\coeffs1_l,		Y+0
	ldd		\coeffs1_h,		Y+1
	
	mc_mulsu16x16_32	\coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h
	mc_LUT_reduce_asm	\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh
	mc_small_LUT_reduce_asm	\zero, \coeffs1_l, \coeffs1_h, \tmp_integer

	movw	\coeffs2_l,		\coeffs1_l
	add		\coeffs1_l,		\res_l
	adc		\coeffs1_h,		\res_h
	sub		\coeffs2_l,		\res_l
	sbc		\coeffs2_h,		\res_h

	dec		r26
	st		X+,				\coeffs2_l
	st		X+,				\coeffs2_h
	st		Y+,				\coeffs1_l
	st		Y+,				\coeffs1_h
.endm

.macro mc_LUT_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	ld		\coeffs1_l,		X+
	ld		\coeffs1_h,		X
	ldd		\coeffs2_l,		Y+0
	ldd		\coeffs2_h,		Y+1
	
	movw	\tmp_ll,		\coeffs1_l
	add		\coeffs1_l,		\coeffs2_l
	adc		\coeffs1_h,		\coeffs2_h
	mc_small_LUT_reduce_asm	\zero, \coeffs1_l, \coeffs1_h, \tmp_integer

	sub		\coeffs2_l,		\tmp_ll
	sbc		\coeffs2_h,		\tmp_lh

	mc_mulsu16x16_32	\coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h
	mc_LUT_reduce_asm	\tmp_integer, \coeffs2_l, \coeffs2_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh

	dec		r26
	st		X+,				\coeffs1_l
	st		X+,				\coeffs1_h
	st		Y+,				\coeffs2_l
	st		Y+,				\coeffs2_h
.endm

.macro mc_LUT_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	ld		\coeffs2_l,		X+
	ld		\coeffs2_h,		X
	ldd		\coeffs1_l,		Y+0
	ldd		\coeffs1_h,		Y+1
	
	movw	\tmp_ll,		\coeffs1_l
	add		\coeffs1_l,		\coeffs2_l
	adc		\coeffs1_h,		\coeffs2_h
	mc_small_LUT_reduce_asm	\zero, \coeffs1_l, \coeffs1_h, \tmp_integer

	sub		\coeffs2_l,		\tmp_ll
	sbc		\coeffs2_h,		\tmp_lh

	mc_mulsu16x16_32	\coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h
	mc_LUT_reduce_asm	\tmp_integer, \coeffs2_l, \coeffs2_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh

	dec		r26
	st		X+,				\coeffs2_l
	st		X+,				\coeffs2_h
	st		Y+,				\coeffs1_l
	st		Y+,				\coeffs1_h
.endm

.macro mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	ld		\coeffs1_l,		X+
	ld		\coeffs1_h,		X
	ldd		\coeffs2_l,		Y+0
	ldd		\coeffs2_h,		Y+1
	
	movw	\tmp_ll,		\coeffs1_l
	add		\coeffs1_l,		\coeffs2_l
	adc		\coeffs1_h,		\coeffs2_h
	sub		\coeffs2_l,		\tmp_ll
	sbc		\coeffs2_h,		\tmp_lh

	mc_mulsu16x16_32	\coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h
	mc_LUT_reduce_asm	\tmp_integer, \coeffs2_l, \coeffs2_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh

	dec		r26
	st		X+,				\coeffs1_l
	st		X+,				\coeffs1_h
	st		Y+,				\coeffs2_l
	st		Y+,				\coeffs2_h
.endm

.macro mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	ld		\coeffs2_l,		X+
	ld		\coeffs2_h,		X
	ldd		\coeffs1_l,		Y+0
	ldd		\coeffs1_h,		Y+1
	
	movw	\tmp_ll,		\coeffs1_l
	add		\coeffs1_l,		\coeffs2_l
	adc		\coeffs1_h,		\coeffs2_h
	sub		\coeffs2_l,		\tmp_ll
	sbc		\coeffs2_h,		\tmp_lh

	mc_mulsu16x16_32	\coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h
	mc_LUT_reduce_asm	\tmp_integer, \coeffs2_l, \coeffs2_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh

	dec		r26
	st		X+,				\coeffs2_l
	st		X+,				\coeffs2_h
	st		Y+,				\coeffs1_l
	st		Y+,				\coeffs1_h
.endm
