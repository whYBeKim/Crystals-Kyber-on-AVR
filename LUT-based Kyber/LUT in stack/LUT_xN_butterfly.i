
/*
 * LUT_Nx_butterfly.i
 *
 * Created: 2023-03-21 오후 9:50:44
 */ 

.macro mc_LUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
									tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
								
								mc_LUT_CTbutterfly_forward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

								mc_LUT_CTbutterfly_forward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

.endm

.macro mc_LUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
									tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
								
								mc_LUT_x2_CTbutterfly_forward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

								mc_LUT_x2_CTbutterfly_forward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

.endm

.macro mc_LUT_x8_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
									tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
								
								mc_LUT_x4_CTbutterfly_forward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

								mc_LUT_x4_CTbutterfly_forward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

.endm

.macro mc_LUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
									tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
								
								mc_LUT_CTbutterfly_backward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

								mc_LUT_CTbutterfly_backward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

.endm

.macro mc_LUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
									tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
								
								mc_LUT_x2_CTbutterfly_backward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

								mc_LUT_x2_CTbutterfly_backward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

.endm

.macro mc_LUT_x8_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
									tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
								
								mc_LUT_x4_CTbutterfly_backward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

								mc_LUT_x4_CTbutterfly_backward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

.endm

.macro mc_ssLUT_x2_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
									tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
								
								mc_ssLUT_CTbutterfly_forward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

								mc_ssLUT_CTbutterfly_forward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

.endm

.macro mc_ssLUT_x4_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
									tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
								
								mc_ssLUT_x2_CTbutterfly_forward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

								mc_ssLUT_x2_CTbutterfly_forward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

.endm

.macro mc_ssLUT_x8_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
									tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
								
								mc_ssLUT_x4_CTbutterfly_forward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

								mc_ssLUT_x4_CTbutterfly_forward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

.endm

.macro mc_ssLUT_x16_CTbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
									tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
								
								mc_ssLUT_x8_CTbutterfly_forward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

								mc_ssLUT_x8_CTbutterfly_forward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

.endm

.macro mc_ssLUT_x2_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
									tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
								
								mc_ssLUT_CTbutterfly_backward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

								mc_ssLUT_CTbutterfly_backward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

.endm

.macro mc_ssLUT_x4_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
									tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
								
								mc_ssLUT_x2_CTbutterfly_backward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

								mc_ssLUT_x2_CTbutterfly_backward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

.endm

.macro mc_ssLUT_x8_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
									tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
								
								mc_ssLUT_x4_CTbutterfly_backward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

								mc_ssLUT_x4_CTbutterfly_backward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

.endm

.macro mc_ssLUT_x16_CTbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
									tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h
								
								mc_ssLUT_x8_CTbutterfly_backward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

								mc_ssLUT_x8_CTbutterfly_backward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h

.endm

.macro mc_LUT_x2_no_ss_GSbutterfly_forward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
									tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
								
								mc_LUT_no_ss_GSbutterfly_forward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h 
								
								mc_LUT_no_ss_GSbutterfly_forward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h 
.endm

.macro mc_LUT_x2_no_ss_GSbutterfly_backward coeffs1_l, coeffs1_h, coeffs2_l, coeffs2_h, zetas_l, zetas_h, tmp_addr_l, tmp_addr_h,\
									tmp_integer, res_l, res_h, tmp_ll, tmp_lh, tmp_hl, tmp_hh, zero, res_mul_l, res_mul_h 
								
								mc_LUT_no_ss_GSbutterfly_backward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h 
								
								mc_LUT_no_ss_GSbutterfly_backward \coeffs1_l, \coeffs1_h, \coeffs2_l, \coeffs2_h, \zetas_l, \zetas_h, \tmp_addr_l, \tmp_addr_h,\
								\tmp_integer, \res_l, \res_h, \tmp_ll, \tmp_lh, \tmp_hl, \tmp_hh, \zero, \res_mul_l, \res_mul_h 
.endm


