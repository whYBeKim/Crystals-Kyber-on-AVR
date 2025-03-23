
/*
 * mul_asm.i
 *
 * Created: 2023-03-22 오후 10:04:15
 */ 

  /**************************************************
  *	macro : mc_mulsu16x16_32
  *	description : Signed with Unsigned multiply of two 16bits numbers with 32bits result.
  * usage: int32_t c3|c2|c1|c0 = (Signed int16_t a1|a0) * (UnSigned int16_t b1|b0)
  * register usage : 11 registers
  * clock cycles : 17
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
  * clock cycles : 18
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
