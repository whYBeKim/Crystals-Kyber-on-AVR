
/*
 * LUT_invntt.S
 *
 * Created: 2023-03-23 오후 12:54:37
 */ 
.section .text
#include "LUT_butterfly.i"
#include "LUT_xN_butterfly.i"
#include "common.i"
#include "mul_asm.i"

#define res_mul_l		r0
#define res_mul_h		r1
#define loop_cnt		r2
#define tmp_cnt			r3
#define tmp_hl			r4
#define tmp_hh			r5
#define zeta_addr_l		r6
#define zeta_addr_h		r7
#define init_addr_l		r8
#define init_addr_h		r9
#define	res_l			r10
#define	res_h			r11
#define	tmp_addr_l		r12
#define	tmp_addr_h		r13
#define	zero			r14
#define	tmp_integer		r17
#define	zetas_l			r18
#define	zetas_h			r19
#define	coeffs1_l		r20
#define	coeffs1_h		r21
#define	coeffs2_l		r22
#define	coeffs2_h		r23
#define tmp_ll			r24
#define tmp_lh			r25

.global	LUT_invntt_asm
.type	LUT_invntt_asm, @function

LUT_invntt_asm : 
	mc_prolog 0, 17

	clr		zero
	movw	r26,		r24 
	movw	r28,		r24 
	movw	init_addr_l,r24 

Layer0:

	ldi		zetas_l,	lo8(ntt_zetas)	
	ldi		zetas_h,	hi8(ntt_zetas)
	ldi		r16,		128
	add		zetas_l,	r16
	adc		zetas_h,	zero	
	movw	zeta_addr_l,zetas_l

	ldi		r16,		32
	mov		tmp_cnt,	r16
	mov		loop_cnt,	tmp_cnt

	ldi		r16,		4
	add		r28,		r16

000:
	movw	r30,		zeta_addr_l
	ld		zetas_h,	-Z
	ld		zetas_l,	-Z
	movw	zeta_addr_l,r30

	mc_LUT_x2_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	
	add		r26,		r16
	add		r28,		r16
	dec		loop_cnt
	breq	001f
	rjmp	000b

001:
	inc		r27
	mov		loop_cnt,	tmp_cnt

002:
	movw	r30,		zeta_addr_l
	ld		zetas_h,	-Z
	ld		zetas_l,	-Z
	movw	zeta_addr_l,r30

	mc_LUT_x2_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	
	add		r26,		r16
	add		r28,		r16
	dec		loop_cnt
	breq	003f
	rjmp	002b

003:

Layer1:

	movw	r26,		init_addr_l
	movw	r28,		init_addr_l
	ldi		r16,		4
	mov		tmp_cnt,	r16
	mov		loop_cnt,	tmp_cnt
	ldi		r16,		8
	add		r28,		r16
	ldi		r16,		16
	ldi		zetas_l,	0x8E
	ldi		zetas_h,	0x03

100:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	100b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0xCB
	ldi		zetas_h,	0x04

101:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	101b

	mov		loop_cnt,	tmp_cnt							
	add		r28,		r16
	ldi		zetas_l,	0x26
	ldi		zetas_h,	0x0C

102:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	102b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0xAA
	ldi		zetas_h,	0x09

103:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	103b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0x88
	ldi		zetas_h,	0x02

104:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	104b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0xC9
	ldi		zetas_h,	0x05

105:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	105b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0x39
	ldi		zetas_h,	0x0A

106:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	
	dec		loop_cnt
	brne	106b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x57
	ldi		zetas_h,	0x0A

107:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	107b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0x62
	ldi		zetas_h,	0x09

108:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	
	dec		loop_cnt
	brne	108b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0xFE
	ldi		zetas_h,	0x05

109:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	109b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0x34
	ldi		zetas_h,	0x0B

110:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	110b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x9E
	ldi		zetas_h,	0x05

111:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	111b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0xC4
	ldi		zetas_h,	0x01

112:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	112b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x27
	ldi		zetas_h,	0x03

113:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	113b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0x9B
	ldi		zetas_h,	0x05

114:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	114b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x0F
	ldi		zetas_h,	0x09

115:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	115b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	adc		r29,		zero
	ldi		zetas_l,	0x7B
	ldi		zetas_h,	0x07

116:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	116b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x28
	ldi		zetas_h,	0x05

117:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	117b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0x21
	ldi		zetas_h,	0x00

118:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	118b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x31
	ldi		zetas_h,	0x0B

119:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	119b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0x78
	ldi		zetas_h,	0x02

120:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	120b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0xD1
	ldi		zetas_h,	0x09

121:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	121b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0xB9
	ldi		zetas_h,	0x07

122:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	122b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x8A
	ldi		zetas_h,	0x02

123:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	123b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0x07
	ldi		zetas_h,	0x08

124:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	124b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0xE5
	ldi		zetas_h,	0x08

125:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	125b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0x00
	ldi		zetas_h,	0x09

126:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	126b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0xAD
	ldi		zetas_h,	0x04

127:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	127b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0xDC
	ldi		zetas_h,	0x06

128:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	128b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0xB5
	ldi		zetas_h,	0x0C

129:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	129b

	mov		loop_cnt,	tmp_cnt									
	add		r28,		r16
	ldi		zetas_l,	0x4B
	ldi		zetas_h,	0x01

130:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	130b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x21
	ldi		zetas_h,	0x01

131:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	131b

Layer2:
	movw	r26,		init_addr_l
	movw	r28,		init_addr_l
	ldi		r16,		8
	mov		tmp_cnt,	r16
	mov		loop_cnt,	tmp_cnt
	ldi		r16,		16
	add		r28,		r16
	ldi		r16,		32
	ldi		zetas_l,	0x35
	ldi		zetas_h,	0x03

200:
	mc_LUT_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	200b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0xB6
	ldi		zetas_h,	0x07

201:
	mc_LUT_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	201b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0x3F
	ldi		zetas_h,	0x0B

202:
	mc_LUT_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	202b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x59
	ldi		zetas_h,	0x09

203:
	mc_LUT_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	203b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0x42
	ldi		zetas_h,	0x0B

204:
	mc_LUT_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	204b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x17
	ldi		zetas_h,	0x02

205:
	mc_LUT_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	205b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0x2E
	ldi		zetas_h,	0x08

206:
	mc_LUT_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	206b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x92
	ldi		zetas_h,	0x05

207:
	mc_LUT_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	207b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	adc		r29,		zero
	ldi		zetas_l,	0x35
	ldi		zetas_h,	0x05

208:
	mc_LUT_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	208b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0xC0
	ldi		zetas_h,	0x08

209:
	mc_LUT_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	209b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0x38
	ldi		zetas_h,	0x00

210:
	mc_LUT_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	210b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0xE6
	ldi		zetas_h,	0x0B

211:
	mc_LUT_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	211b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0xC4
	ldi		zetas_h,	0x05

212:
	mc_LUT_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	212b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x3B
	ldi		zetas_h,	0x05

213:
	mc_LUT_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	213b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0x8F
	ldi		zetas_h,	0x09

214:
	mc_LUT_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	214b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x28
	ldi		zetas_h,	0x01

215:
	mc_LUT_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	215b

Layer3:
	movw	r26,		init_addr_l
	movw	r28,		init_addr_l
	ldi		r16,		16
	mov		tmp_cnt,	r16
	mov		loop_cnt,	tmp_cnt
	ldi		r16,		32
	add		r28,		r16
	ldi		r16,		64
	ldi		zetas_l,	0xD2
	ldi		zetas_h,	0x06

300:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	300b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x39
	ldi		zetas_h,	0x02

301:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	301b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0xBC
	ldi		zetas_h,	0x0C

302:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	302b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0xE2
	ldi		zetas_h,	0x0A

303:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	303b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	adc		r29,		zero
	ldi		zetas_l,	0x1D
	ldi		zetas_h,	0x03

304:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	304b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0xC1
	ldi		zetas_h,	0x00

305:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	305b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	ldi		zetas_l,	0x7F
	ldi		zetas_h,	0x07

306:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	306b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x26
	ldi		zetas_h,	0x04

307:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	307b


Layer4:
	movw	r26,		init_addr_l
	movw	r28,		init_addr_l
	ldi		r16,		32
	mov		tmp_cnt,	r16
	mov		loop_cnt,	tmp_cnt
	ldi		r16,		64
	add		r28,		r16
	ldi		r16,		128
	ldi		zetas_l,	0x50
	ldi		zetas_h,	0x03

400:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	400b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x69
	ldi		zetas_h,	0x07

401:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	401b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	adc		r29,		zero
	ldi		zetas_l,	0x76
	ldi		zetas_h,	0x02

402:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	402b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x52
	ldi		zetas_h,	0x0A

403:
	mc_LUT_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	403b

Layer5:
	movw	r26,		init_addr_l
	movw	r28,		init_addr_l
	ldi		r16,		64
	mov		tmp_cnt,	r16
	mov		loop_cnt,	tmp_cnt
	ldi		r16,		128
	add		r28,		r16
	ldi		zetas_l,	0xD9
	ldi		zetas_h,	0x0C

500:
	mc_LUT_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
	dec		loop_cnt
	brne	500b

	mov		loop_cnt,	tmp_cnt
	inc		r27
	ldi		zetas_l,	0x14
	ldi		zetas_h,	0x0A

501:
	mc_LUT_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	501b

Layer6:
	movw	r26,		init_addr_l
	movw	r28,		init_addr_l
	ldi		r16,		128
	mov		loop_cnt,	r16
	inc		r29
	ldi		zetas_l,	0x74 // 0x0674 == 1652  == (3303 * 1729) % 3329
	ldi		zetas_h,	0x06

600:
	mc_LUT_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
								tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 

	dec		loop_cnt
	brne	600b

two_power:
	movw	r28,			init_addr_l
	ldi		r16,			128
	ldi		zetas_l,		0xE7 // 0x0CE7 == 1/128 % 3329 == 3303
	ldi		zetas_h,		0x0C

700:
	ldd		coeffs1_l,		Y+0
	ldd		coeffs1_h,		Y+1

	mc_mulsu16x16_32	coeffs1_l, coeffs1_h, zetas_l, zetas_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
	mc_LUT_reduce_asm	tmp_integer, coeffs1_l, coeffs1_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh

	st		Y+,				coeffs1_l
	st		Y+,				coeffs1_h

	dec		r16
	brne	700b

end:
	mc_epilog 0, 17
	ret

#undef	res_mul_l	
#undef	res_mul_h	
#undef	loop_cnt		
#undef	tmp_cnt		
#undef	tmp_hl		
#undef	tmp_hh
#undef	zeta_addr_l
#undef	zeta_addr_h
#undef	init_addr_l	
#undef	init_addr_h	
#undef	res_l		
#undef	res_h		
#undef	tmp_addr_l	
#undef	tmp_addr_h	
#undef	zero		
#undef	tmp_integer	
#undef	zetas_l		
#undef	zetas_h		
#undef	coeffs1_l	
#undef	coeffs1_h	
#undef	coeffs2_l	
#undef	coeffs2_h	
#undef	tmp_ll		
#undef	tmp_lh		