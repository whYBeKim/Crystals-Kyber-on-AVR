
/*
 * LUT_ntt.S
 *
 * Created: 2023-03-19 오후 5:36:44
 */ 
 
 #include "mul_asm.i"
 #include "LUT_butterfly.i"
 #include "LUT_xN_butterfly.i"
 #include "common.i"
 
.section .text

#define res_mul_l		r0
#define res_mul_h		r1
#define loop_cnt		r2
#define tmp_cnt			r3
#define tmp_hl			r4
#define tmp_hh			r5
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

.global	LUT_ntt_asm
.type	LUT_ntt_asm, @function

LUT_ntt_asm : 
	mc_prolog 0, 17

	clr		zero
	movw	r26,		r24 
	movw	r28,		r24 
	movw	init_addr_l,r24 
	inc		r29

Layer0:

	ldi		r16,		128
	mov		loop_cnt,	r16
	
	ldi		zetas_l,	0xC1
	ldi		zetas_h,	0x06

000:
	mc_LUT_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							 tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	dec		loop_cnt
	brne	000b
	
Layer1:
	ldi		r16,		64
	mov		tmp_cnt,	r16
	mov		loop_cnt,	tmp_cnt
	movw	r26,		init_addr_l
	movw	r28,		init_addr_l
	ldi		r16,		128
	add		r28,		r16

	ldi		zetas_l,	0x14
	ldi		zetas_h,	0x0A
	

100:
	mc_LUT_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							 tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	dec		loop_cnt
	brne	100b

	mov		loop_cnt,	tmp_cnt
	inc		r27
	ldi		zetas_l,	0xD9
	ldi		zetas_h,	0x0C


101:
	mc_LUT_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
	
	dec		loop_cnt
	brne	101b

layer2:

	ldi		r16,		32
	mov		tmp_cnt,	r16
	mov		loop_cnt,	tmp_cnt
	movw	r26,		init_addr_l
	movw	r28,		init_addr_l
	ldi		r16,		64
	add		r28,		r16
	ldi		zetas_l,	0x52
	ldi		zetas_h,	0x0A
	

200:
	mc_LUT_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							 tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	dec		loop_cnt
	brne	200b

	mov		loop_cnt,	tmp_cnt
	ldi		r16,		128
	add		r26,		r16
	ldi		zetas_l,	0x76
	ldi		zetas_h,	0x02

201:
	mc_LUT_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	dec		loop_cnt
	brne	201b

	mov		loop_cnt,	tmp_cnt
	add		r28,		r16
	adc		r29,		zero
	ldi		zetas_l,	0x69
	ldi		zetas_h,	0x07

202:
	mc_LUT_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							 tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	dec		loop_cnt
	brne	202b

	mov		loop_cnt,	tmp_cnt
	add		r26,		r16
	ldi		zetas_l,	0x50
	ldi		zetas_h,	0x03

203:
	mc_LUT_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	dec		loop_cnt
	brne	203b

layer3:

	movw	r26,		init_addr_l
	movw	r28,		init_addr_l
	ldi		r16,		32
	add		r28,		r16
	ldi		zetas_l,	0x26
	ldi		zetas_h,	0x04
	
300:
	mc_ssLUT_x16_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							 tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h


	ldi		r16,		64
	add		r26,		r16
	ldi		zetas_l,	0x7F
	ldi		zetas_h,	0x07

301:
	mc_ssLUT_x16_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xC1
	ldi		zetas_h,	0x00

302:
	mc_ssLUT_x16_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x1D
	ldi		zetas_h,	0x03

303:
	mc_ssLUT_x16_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	adc		r29,		zero
	ldi		zetas_l,	0xE2
	ldi		zetas_h,	0x0A

304:
	mc_ssLUT_x16_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0xBC
	ldi		zetas_h,	0x0C

305:
	mc_ssLUT_x16_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x39
	ldi		zetas_h,	0x02

306:
	mc_ssLUT_x16_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0xD2
	ldi		zetas_h,	0x06

307:
	mc_ssLUT_x16_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

layer4:

	movw	r26,		init_addr_l
	movw	r28,		init_addr_l
	ldi		r16,		16
	add		r28,		r16
	ldi		zetas_l,	0x28
	ldi		zetas_h,	0x01
	
400:
	mc_LUT_x8_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							 tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	ldi		r16,		32
	add		r26,		r16
	ldi		zetas_l,	0x8F
	ldi		zetas_h,	0x09

401:
	mc_LUT_x8_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x3B
	ldi		zetas_h,	0x05

402:
	mc_LUT_x8_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0xC4
	ldi		zetas_h,	0x05

403:
	mc_LUT_x8_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xE6
	ldi		zetas_h,	0x0B

404:
	mc_LUT_x8_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x38
	ldi		zetas_h,	0x00

405:
	mc_LUT_x8_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xC0
	ldi		zetas_h,	0x08

406:
	mc_LUT_x8_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x35
	ldi		zetas_h,	0x05

407:
	mc_LUT_x8_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	adc		r29,		zero
	ldi		zetas_l,	0x92
	ldi		zetas_h,	0x05

408:
	mc_LUT_x8_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							 tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x2E
	ldi		zetas_h,	0x08

409:
	mc_LUT_x8_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x17
	ldi		zetas_h,	0x02

410:
	mc_LUT_x8_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x42
	ldi		zetas_h,	0x0B

411:
	mc_LUT_x8_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x59
	ldi		zetas_h,	0x09

412:
	mc_LUT_x8_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x3F
	ldi		zetas_h,	0x0B

413:
	mc_LUT_x8_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xB6
	ldi		zetas_h,	0x07

414:
	mc_LUT_x8_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x35
	ldi		zetas_h,	0x03

415:
	mc_LUT_x8_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

layer5:

	movw	r26,		init_addr_l
	movw	r28,		init_addr_l
	ldi		r16,		8
	add		r28,		r16
	ldi		zetas_l,	0x21
	ldi		zetas_h,	0x01
	
500:
	mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							 tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	ldi		r16,		16
	add		r26,		r16
	ldi		zetas_l,	0x4B
	ldi		zetas_h,	0x01

501:
	mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xB5
	ldi		zetas_h,	0x0C

502:
	mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0xDC
	ldi		zetas_h,	0x06

503:
	mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xAD
	ldi		zetas_h,	0x04

504:
	mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x00
	ldi		zetas_h,	0x09

505:
	mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xE5
	ldi		zetas_h,	0x08

506:
	mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x07
	ldi		zetas_h,	0x08

507:
	mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x8A
	ldi		zetas_h,	0x02

508:
	mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0xB9
	ldi		zetas_h,	0x07

509:
	mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xD1
	ldi		zetas_h,	0x09

510:
	mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x78
	ldi		zetas_h,	0x02

511:
	mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x31
	ldi		zetas_h,	0x0B

512:
	mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x21
	ldi		zetas_h,	0x00

513:
	mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x28
	ldi		zetas_h,	0x05

514:
	mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x7B
	ldi		zetas_h,	0x07

515:
	mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	adc		r29,		zero
	ldi		zetas_l,	0x0F
	ldi		zetas_h,	0x09

516:
	mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							 tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x9B
	ldi		zetas_h,	0x05

517:
	mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x27
	ldi		zetas_h,	0x03

518:
	mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0xC4
	ldi		zetas_h,	0x01

519:
	mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x9E
	ldi		zetas_h,	0x05

520:
	mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x34
	ldi		zetas_h,	0x0B

521:
	mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xFE
	ldi		zetas_h,	0x05

522:
	mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x62
	ldi		zetas_h,	0x09

523:
	mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x57
	ldi		zetas_h,	0x0A

524:
	mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x39
	ldi		zetas_h,	0x0A

525:
	mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xC9
	ldi		zetas_h,	0x05

526:
	mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x88
	ldi		zetas_h,	0x02

527:
	mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xAA
	ldi		zetas_h,	0x09

528:
	mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x26
	ldi		zetas_h,	0x0C

529:
	mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xCB
	ldi		zetas_h,	0x04

530:
	mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x8E
	ldi		zetas_h,	0x03

531:
	mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
	
layer6:

	movw	r26,		init_addr_l
	movw	r28,		init_addr_l
	ldi		r16,		4
	add		r28,		r16
	ldi		r16,		8
	ldi		zetas_l,	0x11
	ldi		zetas_h,	0x00
	
600:              
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							 tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0xC9
	ldi		zetas_h,	0x0A

601:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x47
	ldi		zetas_h,	0x02

602:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x59
	ldi		zetas_h,	0x0A

603:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x65
	ldi		zetas_h,	0x06

604:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0xD3
	ldi		zetas_h,	0x02

605:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xF0
	ldi		zetas_h,	0x08

606:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x4C
	ldi		zetas_h,	0x04

607:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x81
	ldi		zetas_h,	0x05

608:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x66
	ldi		zetas_h,	0x0A

609:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xD1
	ldi		zetas_h,	0x0C

610:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0xE9
	ldi		zetas_h,	0x00

611:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xF4
	ldi		zetas_h,	0x02

612:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x6C
	ldi		zetas_h,	0x08

613:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xC7
	ldi		zetas_h,	0x0B

614:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0xEA
	ldi		zetas_h,	0x0B

615:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xA7
	ldi		zetas_h,	0x06

616:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x73
	ldi		zetas_h,	0x06

617:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xE5
	ldi		zetas_h,	0x0A

618:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0xFD
	ldi		zetas_h,	0x06

619:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x37
	ldi		zetas_h,	0x07

620:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0xB8
	ldi		zetas_h,	0x03

621:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xB5
	ldi		zetas_h,	0x05

622:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x7F
	ldi		zetas_h,	0x0A

623:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xAB
	ldi		zetas_h,	0x03

624:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x04
	ldi		zetas_h,	0x09

625:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x85
	ldi		zetas_h,	0x09

626:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x54
	ldi		zetas_h,	0x09

627:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xDD
	ldi		zetas_h,	0x02

628:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
	add		r26,		r16
	ldi		zetas_l,	0x21
	ldi		zetas_h,	0x09

629:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x0C
	ldi		zetas_h,	0x01

630:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x81
	ldi		zetas_h,	0x02

631:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	adc		r29,		zero
	ldi		zetas_l,	0x30
	ldi		zetas_h,	0x06
	
632:              
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							 tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0xFA
	ldi		zetas_h,	0x08

633:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xF5
	ldi		zetas_h,	0x07

634:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x94
	ldi		zetas_h,	0x0C

635:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x77
	ldi		zetas_h,	0x01

636:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0xF5
	ldi		zetas_h,	0x09

637:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x2A
	ldi		zetas_h,	0x08

638:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x6D
	ldi		zetas_h,	0x06

639:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x27
	ldi		zetas_h,	0x04

640:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x3F
	ldi		zetas_h,	0x01

641:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xD5
	ldi		zetas_h,	0x0A

642:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0xF5
	ldi		zetas_h,	0x02

643:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x33
	ldi		zetas_h,	0x08

644:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x31
	ldi		zetas_h,	0x02

645:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xA2
	ldi		zetas_h,	0x09

646:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x22
	ldi		zetas_h,	0x0A

647:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xF4
	ldi		zetas_h,	0x0A

648:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x44
	ldi		zetas_h,	0x04

649:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x93
	ldi		zetas_h,	0x01

650:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x02
	ldi		zetas_h,	0x04

651:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x77
	ldi		zetas_h,	0x04

652:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x66
	ldi		zetas_h,	0x08

653:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xD7
	ldi		zetas_h,	0x0A

654:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x76
	ldi		zetas_h,	0x03

655:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0xBA
	ldi		zetas_h,	0x06

656:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0xBC
	ldi		zetas_h,	0x04

657:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x52
	ldi		zetas_h,	0x07

658:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x05
	ldi		zetas_h,	0x04

659:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x3E
	ldi		zetas_h,	0x08

660:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x77
	ldi		zetas_h,	0x0B

661:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r28,		r16
	ldi		zetas_l,	0x75
	ldi		zetas_h,	0x03

662:
	mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

	add		r26,		r16
	ldi		zetas_l,	0x6A
	ldi		zetas_h,	0x08

663:
	mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
							  tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h

end:
	mc_epilog 0, 17
	ret

#undef res_mul_l	
#undef res_mul_h	
#undef loop_cnt		
#undef tmp_cnt		
#undef tmp_hl		
#undef tmp_hh		
#undef init_addr_l	
#undef init_addr_h	
#undef res_l		
#undef res_h		
#undef tmp_addr_l	
#undef tmp_addr_h	
#undef zero		
#undef tmp_integer	
#undef zetas_l		
#undef zetas_h		
#undef coeffs1_l	
#undef coeffs1_h	
#undef coeffs2_l	
#undef coeffs2_h	
#undef tmp_ll		
#undef tmp_lh		