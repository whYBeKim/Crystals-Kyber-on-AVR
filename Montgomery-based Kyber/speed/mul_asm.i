
/*
 * mul_asm.i
 *
 * Created: 2022-10-14 오전 2:03:02
 *  Author: youngbeom
 */ 

 /**************************************************
  *	macro : mc_mulsu16x16_32
  *	description : Signed with Unsigned multiply of two 16bits numbers with 32bits result.
  * usage: int32_t c3|c2|c1|c0 = (Signed int16_t a1|a0) * (UnSigned int16_t b1|b0)
  * register usage : 11 registers
  ***************************************************/

 .macro mc_mulsu16x16_32 a0, a1, b0, b1, c0, c1, c2, c3, carry, fixed_r0, fixed_r1

	//clr	\carry
	mulsu	\a1, \b1		; (signed)ah * (Unsigned)bh
	movw	\c2, \fixed_r0
	mul	\a0, \b0			; al * bl
	movw	\c0, \fixed_r0
	mulsu	\a1, \b0		; (signed)ah * bl
	sbc	\c3, \carry
	add	\c1, \fixed_r0
	adc	\c2, \fixed_r1
	adc	\c3, \carry
	mul	\b1, \a0			; (Unsigned)bh * al
	add	\c1, \fixed_r0
	adc	\c2, \fixed_r1
	adc	\c3, \carry

.endm


 /**************************************************
  *	macro : mc_muls16x16_32
  *	description : Signed multiply of two 16bits numbers with 32bits result.
  * usage: int32_t c3|c2|c1|c0 = (int16_t a1|a0) * (int16_t b1|b0)
  * register usage : 11 registers
  ***************************************************/

 .macro mc_muls16x16_32 a0, a1, b0, b1, c0, c1, c2, c3, carry, fixed_r0, fixed_r1

	//clr	\carry
	muls	\a1, \b1		; (signed)ah * (signed)bh
	movw	\c2, \fixed_r0
	mul	\a0, \b0			; al * bl
	movw	\c0, \fixed_r0
	mulsu	\a1, \b0		; (signed)ah * bl
	sbc	\c3, \carry
	add	\c1, \fixed_r0
	adc	\c2, \fixed_r1
	adc	\c3, \carry
	mulsu	\b1, \a0		; (signed)bh * al
	sbc	\c3, \carry
	add	\c1, \fixed_r0
	adc	\c2, \fixed_r1
	adc	\c3, \carry

.endm


 /**************************************************
  *	macro : mc_macs16x16_32
  *	description : Signed multiply accumulate of two 16bits numbers with with 32bits result.
  * usage: int32_t c3|c2|c1|c0 += (int16_t a1|a0) * (int16_t b1|b0)
  * register usage : 11 registers
  ***************************************************/
.macro mc_macs16x16_32 a0, a1, b0, b1, c0, c1, c2, c3, carry, fixed_r0, fixed_r1

	//clr	\carry

	muls	\a1, \b1		;(signed)ah * (signed)bh
	add	\c2, \fixed_r0
	adc	\c3, \fixed_r1

	mul	\a0, \b0			; al * bl
	add	\c0, \fixed_r0
	adc	\c1, \fixed_r1
	adc	\c2, \carry
	adc	\c3, \carry

	mulsu	\a1, \b0		;(signed)ah * bl
	sbc	\c3, \carry
	add	\c1, \fixed_r0
	adc	\c2, \fixed_r1
	adc	\c3, \carry

	mulsu	\b1, \a0		; (signed)bh * al
	sbc	\c3, \carry
	add	\c1, \fixed_r0
	adc	\c2, \fixed_r1
	adc	\c3, \carry

.endm


 /**************************************************
  *	macro : mc_montgomery_reduce
  *	description : Montgomery reduction; given a 32-bit integer a, 
  *				  computes 16-bit integer congruent to a * R^-1 mod q, where R=2^16
  * usage: int16_t res1|res0 = motgomery (int32_t a3|a2|a1|a0)
  * register usage : 17 registers
  * note : Registers which hold value of res0, res1, Q_asm0, and Q_asm1 must be in R16 or higher.
  ***************************************************/

.macro mc_montgomery_reduce	a0, a1, a2, a3, res0, res1, t_Qinv0, t_Qinv1, t_Qinv2, t_Qinv3, carry, Qinv_asm0, Qinv_asm1, Q_asm0, Q_asm1, fixed_r0, fixed_r1

	;t = (int16_t)a * 0X3FED;
	mul \Qinv_asm0, \a0		
	movw	\res0, \fixed_r0
	mul	\a1, \Qinv_asm0
	add	\res1, \fixed_r0
	mul	\Qinv_asm1, \a0
	add	\res1, \fixed_r0
	
	;t = (int32_t)t * 0XEEFD)
	mc_mulsu16x16_32	\res0, \res1, \Q_asm0, \Q_asm1, \t_Qinv0, \t_Qinv1, \t_Qinv2, \t_Qinv3, \carry, \fixed_r0, \fixed_r1
	
	;t = t >> 16;
	sub	\a0, \t_Qinv0
	sbc	\a1, \t_Qinv1
	sbc	\a2, \t_Qinv2
	sbc	\a3, \t_Qinv3
	movw \res0, \a2

.endm

 /**************************************************
  *	macro : mc_barrett_reduce
  *	description : Barrett reduction; given a 16-bit integer a, computes
  *               centered representative congruent to a mod q in {-(q-1)/2,...,(q-1)/2}
  * usage: int16_t res1|res0 = barrett_reduce (int16_t a1|a0)
  * register usage : 13 registers
  * note : Registers which hold value of a0, a1, barret0, barret1, \tmp2, and \tmp3 must be in R16 or higher.
  ***************************************************/

.macro mc_barrett_reduce	a0, a1, tmp0, tmp1, tmp2, tmp3, carry, barret0, barret1, Q0, Q1, fixed_r0, fixed_r1

	ldi	\barret0, lo8(barret_asm)
	ldi	\barret1, hi8(barret_asm)

	mc_mulsu16x16_32 \a0, \a1, \barret0, \barret1, \tmp0, \tmp1, \tmp2, \tmp3, \carry, \fixed_r0, \fixed_r1
 
	inc	\carry
	inc \carry
	add	\tmp3, \carry
	clr	\carry
	asr	\tmp3
	asr	\tmp3

	ldi	\barret0, lo8(Q_asm)
	ldi	\barret1, hi8(Q_asm)

	muls	\tmp3, \barret0
	movw	\tmp0, \fixed_r0
	muls	\tmp3,	\barret1    
	add	\tmp1, \fixed_r0
	sub	\a0, \tmp0
	sbc	\a1, \tmp1

.endm

 /**************************************************
  *	macro : mc_butterfly
  *	description : Cooly-Tukey butterfly
  * usage: (int16_t a0|a1, int16_t b0|b1) = (int16_t a0|a1 + (b0|b1 * zetas0|zetas1), int16_t a0|a1 - (b0|b1 * zetas0|zetas1))
  * register usage : 23 registers
  ***************************************************/
.macro mc_butterfly	a0, a1, b0, b1, zetas0, zetas1, c0, c1, c2, c3, carry, fixed_r0, fixed_r1, res_mont0, res_mont1, tmp0, tmp1, tmp2, tmp3, Qinv0, Qinv1, Q0, Q1

	ldd	\b0, Z+0
	ldd	\b1, Z+1

	mc_muls16x16_32 \b0, \b1, \zetas0, \zetas1, \c0, \c1, \c2, \c3, \carry, \fixed_r0, \fixed_r1
	mc_montgomery_reduce \c0, \c1, \c2, \c3, \res_mont0, \res_mont1, \tmp0, \tmp1, \tmp2, \tmp3, \carry, \Qinv0, \Qinv1, \Q0, \Q1, \fixed_r0, \fixed_r1

	ldd	\a0, Y+0
	ldd	\a1, Y+1

	movw	\b0, \a0

	add	\a0, \res_mont0
	adc	\a1, \res_mont1
	sub	\b0, \res_mont0
	sbc	\b1, \res_mont1

	st	Y+, \a0
	st	Y+, \a1
	st	Z+, \b0
	st	Z+, \b1

.endm


/**************************************************
  *	macro : mc_inv_butterfly
  *	description : Gentleman-Sande butterfly
  * usage: (int16_t a0|a1, int16_t b0|b1) = (int16_t a0|a1 + b0|b1), int16_t (b0|b1 - a0|a1) * zetas0|zetas1))
  * register usage : 25 registers
  ***************************************************/
.macro mc_inv_butterfly	a0, a1, b0, b1, zetas0, zetas1, c0, c1, c2, c3, carry, fixed_r0, fixed_r1, res_mont0, res_mont1, tmp0, tmp1, tmp2, tmp3, Qinv0, Qinv1, Q0, Q1, barret0, barret1

	ldd	\a0, Y+0
	ldd	\a1, Y+1
	movw	r12, \a0

	ldd	\b0, Z+0
	ldd	\b1, Z+1
	movw	r8, \b0

	add	\b0, \a0
	adc	\b1, \a1

	mc_barrett_reduce	\b0, \b1, \tmp0, \tmp1, r22, r23, \carry, \barret0, \barret1, \Q0, \Q1, \fixed_r0, \fixed_r1

	st	Y+, \b0
	st	Y+, \b1

	movw	\b0, r8
	movw	\a0, r12

	sub	\b0, \a0
	sbc	\b1, \a1

	ldi	\Q0, lo8(Q_asm)
	ldi	\Q1, hi8(Q_asm)

	mc_muls16x16_32 \b0, \b1, \zetas0, \zetas1, \c0, \c1, \c2, \c3, \carry, \fixed_r0, \fixed_r1
	mc_montgomery_reduce \c0, \c1, \c2, \c3, \res_mont0, \res_mont1, \tmp0, \tmp1, \tmp2, \tmp3, \carry, \Qinv0, \Qinv1, \Q0, \Q1, \fixed_r0, \fixed_r1


	st	Z+, \res_mont0
	st	Z+, \res_mont1

.endm
