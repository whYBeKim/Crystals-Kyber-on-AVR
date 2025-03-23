/*
 * field.c
 *
 * Created: 2018-07-29 오후 3:33:11
 *  Author: 서석충
 */ 

#include "field.h"

/*
 * Bit reflection table
 */
U8 bitReflectTB[256] = { 0x00, 0x80, 0x40, 0xC0, 0x20, 0xA0, 0x60, 0xE0, 0x10, 0x90, 0x50, 0xD0, 0x30, 0xB0, 0x70, 0xF0,
	0x08, 0x88, 0x48, 0xC8, 0x28, 0xA8, 0x68, 0xE8, 0x18, 0x98, 0x58, 0xD8, 0x38, 0xB8, 0x78, 0xF8,
	0x04, 0x84, 0x44, 0xC4, 0x24, 0xA4, 0x64, 0xE4, 0x14, 0x94, 0x54, 0xD4, 0x34, 0xB4, 0x74, 0xF4,
	0x0C, 0x8C, 0x4C, 0xCC, 0x2C, 0xAC, 0x6C, 0xEC, 0x1C, 0x9C, 0x5C, 0xDC, 0x3C, 0xBC, 0x7C, 0xFC,
	0x02, 0x82, 0x42, 0xC2, 0x22, 0xA2, 0x62, 0xE2, 0x12, 0x92, 0x52, 0xD2, 0x32, 0xB2, 0x72, 0xF2,
	0x0A, 0x8A, 0x4A, 0xCA, 0x2A, 0xAA, 0x6A, 0xEA, 0x1A, 0x9A, 0x5A, 0xDA, 0x3A, 0xBA, 0x7A, 0xFA,
	0x06, 0x86, 0x46, 0xC6, 0x26, 0xA6, 0x66, 0xE6, 0x16, 0x96, 0x56, 0xD6, 0x36, 0xB6, 0x76, 0xF6,
	0x0E, 0x8E, 0x4E, 0xCE, 0x2E, 0xAE, 0x6E, 0xEE, 0x1E, 0x9E, 0x5E, 0xDE, 0x3E, 0xBE, 0x7E, 0xFE,
	0x01, 0x81, 0x41, 0xC1, 0x21, 0xA1, 0x61, 0xE1, 0x11, 0x91, 0x51, 0xD1, 0x31, 0xB1, 0x71, 0xF1,
	0x09, 0x89, 0x49, 0xC9, 0x29, 0xA9, 0x69, 0xE9, 0x19, 0x99, 0x59, 0xD9, 0x39, 0xB9, 0x79, 0xF9,
	0x05, 0x85, 0x45, 0xC5, 0x25, 0xA5, 0x65, 0xE5, 0x15, 0x95, 0x55, 0xD5, 0x35, 0xB5, 0x75, 0xF5,
	0x0D, 0x8D, 0x4D, 0xCD, 0x2D, 0xAD, 0x6D, 0xED, 0x1D, 0x9D, 0x5D, 0xDD, 0x3D, 0xBD, 0x7D, 0xFD,
	0x03, 0x83, 0x43, 0xC3, 0x23, 0xA3, 0x63, 0xE3, 0x13, 0x93, 0x53, 0xD3, 0x33, 0xB3, 0x73, 0xF3,
	0x0B, 0x8B, 0x4B, 0xCB, 0x2B, 0xAB, 0x6B, 0xEB, 0x1B, 0x9B, 0x5B, 0xDB, 0x3B, 0xBB, 0x7B, 0xFB,
	0x07, 0x87, 0x47, 0xC7, 0x27, 0xA7, 0x67, 0xE7, 0x17, 0x97, 0x57, 0xD7, 0x37, 0xB7, 0x77, 0xF7,
0x0F, 0x8F, 0x4F, 0xCF, 0x2F, 0xAF, 0x6F, 0xEF, 0x1F, 0x9F, 0x5F, 0xDF, 0x3F, 0xBF, 0x7F, 0xFF, };

/*
 * Reduction with f = f^128+f^7+f^2+f+1
 */
void reduce(U8* a) {
	int i;
	U8 t;

	t = a[DBLBLOCKS - 1];
	a[DBLBLOCKS - 1 - 15] ^= t >> 6 ^ t >> 1;
	a[DBLBLOCKS - 1 - 16] ^= t ^ t << 1 ^ t << 2 ^ t << 7;
	for (i = 30; i >= 16; i--) {
		t = a[i];
		a[i - 15] ^= t >> 7 ^ t >> 6 ^ t >> 1;
		a[i - 16] ^= t ^ t << 1 ^ t << 2 ^ t << 7;
	}
}

RET bf_rtl_comb_32bit(U8* ret, U8* opA, U8* opB)
{
	U8 cnt_i, cnt_j, cnt_k;
	U8 ta[BLOCKS + 1];			// Will contain a and its shifts
	U8 t[DBLBLOCKS];			// Will contain the product polynomial

	/* Set ta = a */
	for (cnt_i = 0; cnt_i < BLOCKS; cnt_i++)
	{
		ta[cnt_i] = opA[cnt_i];
	}
	ta[BLOCKS] = 0;

	/* Set t = 0 */
	for (cnt_i = 0; cnt_i < DBLBLOCKS; cnt_i++)
	{
		t[cnt_i] = 0;
	}

	/* Right to left comb method */
	for (cnt_j = 1; cnt_j; cnt_j <<= 1)
	{
		for (cnt_i = 0; cnt_i < 4; cnt_i++)
		{
			if (opB[cnt_i] & cnt_j)
			{
				for (cnt_k = 0; cnt_k < 5; cnt_k++)
				{
					t[cnt_i + cnt_k] ^= ta[cnt_k];
				}
			}
		}
		for (cnt_i = 4; cnt_i > 0; cnt_i--)
		{
			ta[cnt_i] = ta[cnt_i] << 1 ^ ta[cnt_i - 1] >> 7;
		}
		ta[0] = ta[0] << 1;
	}

	/* Set c */
	for (cnt_i = 0; cnt_i < BLOCKS; cnt_i++)
	ret[cnt_i] = t[cnt_i];
}

void ff_mul_lrcomb(U8* a, U8* b, U8* c) {
	int i, k;
	U8 j;

	U8 t[DBLBLOCKS]; // Will contain the product polynomial
	U8* ap = a; // Pointer to beginning of a
	U8* bp = b; // Pointer to beginning of a

	/* Set t = 0 */
	for (i = 0; i<DBLBLOCKS; i++)
	t[i] = 0;

	/* Left to right comb method */
	for (j = (U8)1 << 7; j; j >>= 1) {
		for (i = 0; i<BLOCKS; i++) {
			if (ap[i] & j)
			for (k = 0; k<BLOCKS; k++)
			t[i + k] ^= bp[k];
		}
		if (j != 1) {
			for (i = DBLBLOCKS - 1; i>0; i--)
			t[i] = t[i] << 1 ^ t[i - 1] >> 7;
			t[0] = t[0] << 1;
		}
	}

	/* Reduce */
	//reduce(t);

	/* Set c */
	for (i = 0; i < DBLBLOCKS; i++)
	{
		c[i] = t[i];
	}
}

U8 accu[DBLBLOCKS] = {0x00, };
	
U8 L[BLOCKS] = { 0x00, };
U8 H[BLOCKS] = { 0x00, };
U8 M[BLOCKS] = { 0x00, };
	
U8 TA[BLOCKS] = { 0x00, };			// bit reflected opA
U8 TB[BLOCKS] = { 0x00, };			// bit reflected opB
	
U8 tempA[8] = { 0x00, };
U8 tempB[8] = { 0x00, };
S8 cnt_i;

//U8 intermediate_array[48];
extern U8 intermediate_array[];

RET bf_Kara_rtl_comb_128bit_ASM_Ver2_C(U8* ret, U8* opA, U8* opB)
{
	for (cnt_i = 0; cnt_i < BLOCKS; cnt_i++)
	{
		TA[cnt_i] = bitReflectTB[opA[cnt_i]];				// applying bit reflection
		TB[cnt_i] = bitReflectTB[opB[cnt_i]];				// applying bit reflection
	}
	
	//bf_kara_rtl_comb_64bit_ASM_Ver2(L, TA, TB);
	//bf_kara_rtl_comb_64bit_ASM_Ver2(H, TA+8, TB + 8);

	//bf_rtl_comb_64bit_with_encoding_ASM(L, TA, TB);
	//bf_rtl_comb_64bit_with_encoding_ASM(H, TA+8, TB + 8);
	bf_rtl_comb_64bit_with_encoding_ASM(&intermediate_array[0], TA, TB);
	bf_rtl_comb_64bit_with_encoding_ASM(&intermediate_array[32], TA+8, TB + 8);

	//for (cnt_i = 0; cnt_i < 16; cnt_i++)
	//{
		////accu[cnt_i] = L[cnt_i];
		////accu[cnt_i+16] = H[cnt_i];
		//accu[cnt_i] = intermediate_array[cnt_i];
		//accu[cnt_i+16] = intermediate_array[32+cnt_i];
	//}

	bf_add_64bit_asm(tempA, TA, TA+8);
	bf_add_64bit_asm(tempB, TB, TB+8);
	
	//bf_kara_rtl_comb_64bit_ASM_Ver2(M, tempA, tempB);
	//bf_rtl_comb_64bit_with_encoding_ASM(M, tempA, tempB);
	bf_rtl_comb_64bit_with_encoding_ASM(&intermediate_array[16], tempA, tempB);
	
	// 321 cc 소요
	//for (cnt_i = 0; cnt_i < 16; cnt_i++)
	//{
		////accu[cnt_i+8] ^= (M[cnt_i] ^ H[cnt_i] ^ L[cnt_i]);
		//accu[cnt_i+8] ^= (intermediate_array[cnt_i+16] ^ intermediate_array[cnt_i+32] ^ intermediate_array[cnt_i]);
	//}

	bf_add_128bit_accu_asm(accu, intermediate_array);
	
	reduce(accu);
	
	for (cnt_i = 0; cnt_i < BLOCKS; cnt_i++)
	{
		ret[cnt_i] = bitReflectTB[accu[cnt_i]];	// applying reverse bit reflection
	}
}

//RET bf_Kara_rtl_comb_128bit_ASM_Ver2_C(U8* ret, U8* opA, U8* opB)
//{
	//U8 M[BLOCKS] = { 0x00, };
	//
	//U8 tempA[8] = { 0x00, };
	//U8 tempB[8] = { 0x00, };
	//
	//S8 cnt_i;
	//
	//bf_kara_rtl_comb_64bit_ASM_Ver2(ret, opA, opB);
	//bf_kara_rtl_comb_64bit_ASM_Ver2(ret+16, opA+8, opB+8);
	//
	//for (cnt_i = 0; cnt_i < 8; cnt_i++)
	//{
		//tempA[cnt_i] = opA[cnt_i] ^ opA[cnt_i + 8];
		//tempB[cnt_i] = opB[cnt_i] ^ opB[cnt_i + 8];
	//}
	//
	//for (cnt_i = 0; cnt_i < 16; cnt_i++)
	//{
		//M[cnt_i] = ret[cnt_i] ^ ret[cnt_i + 16];
	//}
//
	////bf_add_64bit_asm(tempA, opA, opA+8);
	////bf_add_64bit_asm(tempB, opB, opB+8);
	////bf_add_128bit_asm(M, ret, ret+16);
//
	//bf_kara_rtl_comb_64bit_ASM_Ver2(M, tempA, tempB);
	//
	////bf_add_128bit_asm(ret+8, ret+8, M);
	//
	//for (cnt_i = 0; cnt_i < 16; cnt_i++)
	//{
		//ret[cnt_i + 8] ^= (M[cnt_i]);
	//}
//}

// EOF