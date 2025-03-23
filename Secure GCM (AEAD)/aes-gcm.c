/*
 * Galois/Counter Mode (GCM) and GMAC with AES
 *
 * Copyright (c) 2012, Jouni Malinen <j@w1.fi>
 *
 * This software may be distributed under the terms of the BSD license.
 * See README for more details.
 */

#include "aes_gcm.h"

#include "includes.h"
#include "os.h"
#include "aes.h"
#include "field.h"

//u8 bitReflectTB[256] = { 0x00, 0x80, 0x40, 0xC0, 0x20, 0xA0, 0x60, 0xE0, 0x10, 0x90, 0x50, 0xD0, 0x30, 0xB0, 0x70, 0xF0,
	//0x08, 0x88, 0x48, 0xC8, 0x28, 0xA8, 0x68, 0xE8, 0x18, 0x98, 0x58, 0xD8, 0x38, 0xB8, 0x78, 0xF8,
	//0x04, 0x84, 0x44, 0xC4, 0x24, 0xA4, 0x64, 0xE4, 0x14, 0x94, 0x54, 0xD4, 0x34, 0xB4, 0x74, 0xF4,
	//0x0C, 0x8C, 0x4C, 0xCC, 0x2C, 0xAC, 0x6C, 0xEC, 0x1C, 0x9C, 0x5C, 0xDC, 0x3C, 0xBC, 0x7C, 0xFC,
	//0x02, 0x82, 0x42, 0xC2, 0x22, 0xA2, 0x62, 0xE2, 0x12, 0x92, 0x52, 0xD2, 0x32, 0xB2, 0x72, 0xF2,
	//0x0A, 0x8A, 0x4A, 0xCA, 0x2A, 0xAA, 0x6A, 0xEA, 0x1A, 0x9A, 0x5A, 0xDA, 0x3A, 0xBA, 0x7A, 0xFA,
	//0x06, 0x86, 0x46, 0xC6, 0x26, 0xA6, 0x66, 0xE6, 0x16, 0x96, 0x56, 0xD6, 0x36, 0xB6, 0x76, 0xF6,
	//0x0E, 0x8E, 0x4E, 0xCE, 0x2E, 0xAE, 0x6E, 0xEE, 0x1E, 0x9E, 0x5E, 0xDE, 0x3E, 0xBE, 0x7E, 0xFE,
	//0x01, 0x81, 0x41, 0xC1, 0x21, 0xA1, 0x61, 0xE1, 0x11, 0x91, 0x51, 0xD1, 0x31, 0xB1, 0x71, 0xF1,
	//0x09, 0x89, 0x49, 0xC9, 0x29, 0xA9, 0x69, 0xE9, 0x19, 0x99, 0x59, 0xD9, 0x39, 0xB9, 0x79, 0xF9,
	//0x05, 0x85, 0x45, 0xC5, 0x25, 0xA5, 0x65, 0xE5, 0x15, 0x95, 0x55, 0xD5, 0x35, 0xB5, 0x75, 0xF5,
	//0x0D, 0x8D, 0x4D, 0xCD, 0x2D, 0xAD, 0x6D, 0xED, 0x1D, 0x9D, 0x5D, 0xDD, 0x3D, 0xBD, 0x7D, 0xFD,
	//0x03, 0x83, 0x43, 0xC3, 0x23, 0xA3, 0x63, 0xE3, 0x13, 0x93, 0x53, 0xD3, 0x33, 0xB3, 0x73, 0xF3,
	//0x0B, 0x8B, 0x4B, 0xCB, 0x2B, 0xAB, 0x6B, 0xEB, 0x1B, 0x9B, 0x5B, 0xDB, 0x3B, 0xBB, 0x7B, 0xFB,
	//0x07, 0x87, 0x47, 0xC7, 0x27, 0xA7, 0x67, 0xE7, 0x17, 0x97, 0x57, 0xD7, 0x37, 0xB7, 0x77, 0xF7,
	//0x0F, 0x8F, 0x4F, 0xCF, 0x2F, 0xAF, 0x6F, 0xEF, 0x1F, 0x9F, 0x5F, 0xDF, 0x3F, 0xBF, 0x7F, 0xFF, };

static void inc32(u8 *block)
{
	u32 val;
	val = WPA_GET_BE32(block + AES_BLOCK_SIZE - 4);
	val++;
	WPA_PUT_BE32(block + AES_BLOCK_SIZE - 4, val);
}


static void xor_block(u8 *dst, const u8 *src)
{
	u32 *d = (u32 *) dst;
	u32 *s = (u32 *) src;
	*d++ ^= *s++;
	*d++ ^= *s++;
	*d++ ^= *s++;
	*d++ ^= *s++;
}


static void shift_right_block(u8 *v)
{
	u32 val;

	val = WPA_GET_BE32(v + 12);
	val >>= 1;
	if (v[11] & 0x01)
		val |= 0x80000000;
	WPA_PUT_BE32(v + 12, val);

	val = WPA_GET_BE32(v + 8);
	val >>= 1;
	if (v[7] & 0x01)
		val |= 0x80000000;
	WPA_PUT_BE32(v + 8, val);

	val = WPA_GET_BE32(v + 4);
	val >>= 1;
	if (v[3] & 0x01)
		val |= 0x80000000;
	WPA_PUT_BE32(v + 4, val);

	val = WPA_GET_BE32(v);
	val >>= 1;
	WPA_PUT_BE32(v, val);
}

//void reduce(u8* a) {
	//int i;
	//u8 t;
//
	//t = a[DBLBLOCKS - 1];
	//a[DBLBLOCKS - 1 - 15] ^= t >> 6 ^ t >> 1;
	//a[DBLBLOCKS - 1 - 16] ^= t ^ t << 1 ^ t << 2 ^ t << 7;
	//for (i = 30; i >= 16; i--) {
		//t = a[i];
		//a[i - 15] ^= t >> 7 ^ t >> 6 ^ t >> 1;
		//a[i - 16] ^= t ^ t << 1 ^ t << 2 ^ t << 7;
	//}
//}

/* Multiplication in GF(2^128) */
//static void gf_mult(const u8 *x, const u8 *y, u8 *z)
//{
	//s8 i, k;
	//u8 j;
//
	//u8 tb[BLOCKS + 1] = { 0x00, };				// Will contain b and its shifts
	//u8 ta[BLOCKS] = { 0x00, };
	//u8 t[DBLBLOCKS] = { 0x00, };				// Will contain the product polynomial
//
	///* Set tb = b */
	//for (i = 0; i < BLOCKS; i++)
	//{
		//tb[i] = bitReflectTB[y[i]];				// applying bit-reflection to the multiplicand
	//}
	//tb[BLOCKS] = 0;
//
	///* Set ta = a */
	//for (i = 0; i < BLOCKS; i++)
	//{
		//ta[i] = bitReflectTB[x[i]];				// applying bit-reflection to the multiplier
	//}
//
	///* Right to left comb method */
	//for (j = 1; j; j <<= 1) {
		//for (i = 0; i < BLOCKS; i++) {
			//if (ta[i] & j)
			//for (k = 0; k < BLOCKS + 1; k++)
			//t[i + k] ^= tb[k];
		//}
		//for (i = BLOCKS; i > 0; i--)
		//tb[i] = tb[i] << 1 ^ tb[i - 1] >> 7;
		//tb[0] = tb[0] << 1;
	//}
//
	///* Reduce */
	//reduce(t);
//
	//for (i = 0; i < BLOCKS; i++)
	//{
		//z[i] = bitReflectTB[t[i]];				// applying reverse bit-reflection to the result
	//}
//}


static void ghash_start(u8 *y)
{
	/* Y_0 = 0^128 */
	os_memset(y, 0, 16);
}


static void ghash(const u8 *h, const u8 *x, size_t xlen, u8 *y)
{
	size_t m, i;
	const u8 *xpos = x;
	u8 tmp[16];

	m = xlen / 16;

	for (i = 0; i < m; i++) {
		/* Y_i = (Y^(i-1) XOR X_i) dot H */
		xor_block(y, xpos);
		xpos += 16;

		/* dot operation:
		 * multiplication operation for binary Galois (finite) field of
		 * 2^128 elements */
		//gf_mult(y, h, tmp);
		bf_Kara_rtl_comb_128bit_ASM_Ver2_C(tmp, y, h);
		os_memcpy(y, tmp, 16);
	}

	if (x + xlen > xpos) {
		/* Add zero padded last block */
		size_t last = x + xlen - xpos;
		os_memcpy(tmp, xpos, last);
		os_memset(tmp + last, 0, sizeof(tmp) - last);

		/* Y_i = (Y^(i-1) XOR X_i) dot H */
		xor_block(y, tmp);

		/* dot operation:
		 * multiplication operation for binary Galois (finite) field of
		 * 2^128 elements */
		//gf_mult(y, h, tmp);
		bf_Kara_rtl_comb_128bit_ASM_Ver2_C(tmp, y, h);
		os_memcpy(y, tmp, 16);
	}

	/* Return Y_m */
}

static void secure_ghash(const u8 *h, const u8 *x, size_t xlen, u8 *y, u8* SH)
{
	size_t m, i;
	const u8 *xpos = x;
	u8 tmp[16];

	m = xlen / 16;

	for (i = 0; i < m; i++) {
		/* Y_i = (Y^(i-1) XOR X_i) dot H */
		xor_block(y, xpos);
		xpos += 16;

		/* dot operation:
		* multiplication operation for binary Galois (finite) field of
		* 2^128 elements */
		//gf_mult(y, h, tmp);
		bf_Kara_rtl_comb_128bit_ASM_Ver2_C(tmp, y, h);
		os_memcpy(y, tmp, 16);

		xor_block(y, SH);			// countermeasure
	}

	if (x + xlen > xpos) {
		/* Add zero padded last block */
		size_t last = x + xlen - xpos;
		os_memcpy(tmp, xpos, last);
		os_memset(tmp + last, 0, sizeof(tmp) - last);

		/* Y_i = (Y^(i-1) XOR X_i) dot H */
		xor_block(y, tmp);

		/* dot operation:
		* multiplication operation for binary Galois (finite) field of
		* 2^128 elements */
		//gf_mult(y, h, tmp);
		bf_Kara_rtl_comb_128bit_ASM_Ver2_C(tmp, y, h);
		os_memcpy(y, tmp, 16);

		xor_block(y, SH);			// countermeasure
	}

	/* Return Y_m */
}

static void aes_gctr(void *aes, const u8 *icb, const u8 *x, size_t xlen, u8 *y)
{
	size_t i, n, last;
	u8 cb[AES_BLOCK_SIZE], tmp[AES_BLOCK_SIZE];
	const u8 *xpos = x;
	u8 *ypos = y;

	if (xlen == 0)
		return;

	n = xlen / 16;

	os_memcpy(cb, icb, AES_BLOCK_SIZE);
	/* Full blocks */
	for (i = 0; i < n; i++) {
		aes_encrypt(aes, cb, ypos);
		xor_block(ypos, xpos);
		xpos += AES_BLOCK_SIZE;
		ypos += AES_BLOCK_SIZE;
		inc32(cb);
	}

	last = x + xlen - xpos;
	if (last) {
		/* Last, partial block */
		aes_encrypt(aes, cb, tmp);
		for (i = 0; i < last; i++)
			*ypos++ = *xpos++ ^ tmp[i];
	}
}


static void * aes_gcm_init_hash_subkey(const u8 *key, size_t key_len, u8 *H)
{
	void *aes;

	aes = aes_encrypt_init(key, key_len);
	if (aes == NULL)
		return NULL;

	/* Generate hash subkey H = AES_K(0^128) */
	os_memset(H, 0, AES_BLOCK_SIZE);
	aes_encrypt(aes, H, H);
	/* wpa_hexdump_key(MSG_EXCESSIVE, "Hash subkey H for GHASH",
			H, AES_BLOCK_SIZE); */
	return aes;
}


static void aes_gcm_prepare_j0(const u8 *iv, size_t iv_len, const u8 *H, u8 *J0)
{
	u8 len_buf[16];

	if (iv_len == 12) {
		/* Prepare block J_0 = IV || 0^31 || 1 [len(IV) = 96] */
		os_memcpy(J0, iv, iv_len);
		os_memset(J0 + iv_len, 0, AES_BLOCK_SIZE - iv_len);
		J0[AES_BLOCK_SIZE - 1] = 0x01;
	} else {
		/*
		 * s = 128 * ceil(len(IV)/128) - len(IV)
		 * J_0 = GHASH_H(IV || 0^(s+64) || [len(IV)]_64)
		 */
		ghash_start(J0);
		ghash(H, iv, iv_len, J0);

		// AIDEN - Used to be: WPA_PUT_BE64(len_buf, 0);
		WPA_PUT_BE32(len_buf, 0);
		WPA_PUT_BE32(len_buf + 4, 0);

		// AIDEN - Used to be: WPA_PUT_BE64(len_buf + 8, iv_len * 8);
		WPA_PUT_BE32(len_buf + 8, 0);
		WPA_PUT_BE32(len_buf + 12, iv_len * 8);

		ghash(H, len_buf, sizeof(len_buf), J0);
	}
}


static void aes_gcm_gctr(void *aes, const u8 *J0, const u8 *in, size_t len,
			 u8 *out)
{
	u8 J0inc[AES_BLOCK_SIZE];

	if (len == 0)
		return;

	os_memcpy(J0inc, J0, AES_BLOCK_SIZE);
	inc32(J0inc);
	aes_gctr(aes, J0inc, in, len, out);
}


static void aes_gcm_ghash(const u8 *H, const u8 *aad, size_t aad_len,
			  const u8 *crypt, size_t crypt_len, u8 *S)
{
	u8 len_buf[16];

	/*
	 * u = 128 * ceil[len(C)/128] - len(C)
	 * v = 128 * ceil[len(A)/128] - len(A)
	 * S = GHASH_H(A || 0^v || C || 0^u || [len(A)]64 || [len(C)]64)
	 * (i.e., zero padded to block size A || C and lengths of each in bits)
	 */
	ghash_start(S);
	ghash(H, aad, aad_len, S);
	ghash(H, crypt, crypt_len, S);

	// AIDEN - Used to be: WPA_PUT_BE64(len_buf, aad_len * 8);
	WPA_PUT_BE32(len_buf, 0);
	WPA_PUT_BE32(len_buf + 4, aad_len * 8);

	// AIDEN - Used to be: WPA_PUT_BE64(len_buf + 8, crypt_len * 8);
	WPA_PUT_BE32(len_buf + 8, 0);
	WPA_PUT_BE32(len_buf + 12, crypt_len * 8);

	ghash(H, len_buf, sizeof(len_buf), S);

	/* wpa_hexdump_key(MSG_EXCESSIVE, "S = GHASH_H(...)", S, 16); */
}

static void aes_gcm_secure_ghash(const u8 *H, const u8 *aad, size_t aad_len,
	const u8 *crypt, size_t crypt_len, u8 *S, u8* SH)
{
	u8 len_buf[16];

	/*
	* u = 128 * ceil[len(C)/128] - len(C)
	* v = 128 * ceil[len(A)/128] - len(A)
	* S = GHASH_H(A || 0^v || C || 0^u || [len(A)]64 || [len(C)]64)
	* (i.e., zero padded to block size A || C and lengths of each in bits)
	*/
	//ghash_start(S);
	secure_ghash(H, aad, aad_len, S, SH);						// calling secure ghash with multiplicative masking
	secure_ghash(H, crypt, crypt_len, S, SH);					// calling secure ghash with multiplicative masking

	// AIDEN - Used to be: WPA_PUT_BE64(len_buf, aad_len * 8);
	WPA_PUT_BE32(len_buf, 0);
	WPA_PUT_BE32(len_buf + 4, aad_len * 8);

	// AIDEN - Used to be: WPA_PUT_BE64(len_buf + 8, crypt_len * 8);
	WPA_PUT_BE32(len_buf + 8, 0);
	WPA_PUT_BE32(len_buf + 12, crypt_len * 8);

	secure_ghash(H, len_buf, sizeof(len_buf), S, SH);			// calling secure ghash with multiplicative masking

	/* wpa_hexdump_key(MSG_EXCESSIVE, "S = GHASH_H(...)", S, 16); */
}


/**
 * aes_gcm_ae - GCM-AE_K(IV, P, A)
 * original unsecure version
 */
#if 0
int aes_gcm_ae(const u8 *key, size_t key_len, const u8 *iv, size_t iv_len,
	       const u8 *plain, size_t plain_len,
	       const u8 *aad, size_t aad_len, u8 *crypt, u8 *tag)
{
	u8 H[AES_BLOCK_SIZE];
	u8 J0[AES_BLOCK_SIZE];
	u8 S[16];
	void *aes;
	
	// for side-channel countermeasure
	u8 SH[16] = { 0x00, };
	u8 masking[16] = { 0x1e, 0x2f, 0xe3, 0x92, 0x86, 0x65, 0x73, 0x1c, 0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x38, };
	u8 unmasking[16] = { 0x00, };		// storing (M x H)
	u8 temp[16] = { 0x00, };
	int cnt_i;

	aes = aes_gcm_init_hash_subkey(key, key_len, H);
	if (aes == NULL)
		return -1;

	aes_gcm_prepare_j0(iv, iv_len, H, J0);

	/* C = GCTR_K(inc_32(J_0), P) */
	aes_gcm_gctr(aes, J0, plain, plain_len, crypt);

	aes_gcm_ghash(H, aad, aad_len, crypt, plain_len, S);

	/* T = MSB_t(GCTR_K(J_0, S)) */
	aes_gctr(aes, J0, S, sizeof(S), tag);

	/* Return (C, T) */

	aes_encrypt_deinit(aes);

	return 0;
}
#endif

/**
 * aes_gcm_ae - GCM-AE_K(IV, P, A)
 * secure version with respect to DPA/CPA, and SPA
 */
int aes_gcm_ae(const u8 *key, size_t key_len, const u8 *iv, size_t iv_len,
const u8 *plain, size_t plain_len,
const u8 *aad, size_t aad_len, u8 *crypt, u8 *tag)
{
	u8 H[AES_BLOCK_SIZE];
	u8 J0[AES_BLOCK_SIZE];
	u8 S[16] = { 0x00, };
	void *aes;

	// for side-channel countermeasure
	u8 SH[16] = { 0x00, };
	u8 masking[16] = { 0x1e, 0x2f, 0xe3, 0x92, 0x86, 0x65, 0x73, 0x1c, 0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x38, };
	u8 unmasking[16] = { 0x00, };		// storing (M x H)
	u8 temp[16] = { 0x00, };
	int cnt_i;
	
	for(cnt_i = 0; cnt_i < BLOCKS; cnt_i++)
	{
		masking[cnt_i] = rand();
	}

	aes = aes_gcm_init_hash_subkey(key, key_len, H);
	if (aes == NULL)
	return -1;

	aes_gcm_prepare_j0(iv, iv_len, H, J0);

	/* C = GCTR_K(inc_32(J_0), P) */
	aes_gcm_gctr(aes, J0, plain, plain_len, crypt);

	aes_gctr(aes, J0, temp, sizeof(temp), tag);						// tag = S value (=EK(Y_0))

	// computing M X H
	bf_Kara_rtl_comb_128bit_ASM_Ver2_C(unmasking, masking, H);
	bf_Kara_rtl_comb_128bit_ASM_Ver2_C(SH, tag, H);
	xor_block(SH, tag);												// (S xor SH)
	xor_block(SH, unmasking);										// SH xor S xor MH
	xor_block(SH, masking);											// SH xor S xor MH xor M

	if (aad_len != 0)
	{
		xor_block(aad, tag);											// (A xor S)
		xor_block(aad, masking);										// (A xor S xor M)
	}
	else
	{
		xor_block(crypt, tag);											// (C xor S)
		xor_block(crypt, masking);										// (C xor S xor M)
	}

	aes_gcm_secure_ghash(H, aad, aad_len, crypt, plain_len, S, SH);		// computing secure GHASH, SH is (S xor SH xor M xor MH)

	if (aad_len == 0)
	{
		xor_block(crypt, tag);											// recovering ciphertext
		xor_block(crypt, masking);										// recovering ciphertext
	}

	xor_block(S, masking);												// S xor M
	os_memcpy(tag, S, 16);

	/* Return (C, T) */
	aes_encrypt_deinit(aes);

	return 0;
}

/**
 * aes_gcm_ad - GCM-AD_K(IV, C, A, T)
 */
int aes_gcm_ad(const u8 *key, size_t key_len, const u8 *iv, size_t iv_len,
	       const u8 *crypt, size_t crypt_len,
	       const u8 *aad, size_t aad_len, const u8 *tag, u8 *plain)
{
	u8 H[AES_BLOCK_SIZE];
	u8 J0[AES_BLOCK_SIZE];
	u8 S[16], T[16];
	void *aes;

	aes = aes_gcm_init_hash_subkey(key, key_len, H);
	if (aes == NULL)
		return -1;

	aes_gcm_prepare_j0(iv, iv_len, H, J0);

	/* P = GCTR_K(inc_32(J_0), C) */
	aes_gcm_gctr(aes, J0, crypt, crypt_len, plain);

	aes_gcm_ghash(H, aad, aad_len, crypt, crypt_len, S);

	/* T' = MSB_t(GCTR_K(J_0, S)) */
	aes_gctr(aes, J0, S, sizeof(S), T);

	aes_encrypt_deinit(aes);

	if (os_memcmp_const(tag, T, 16) != 0) {
		/* printf("GCM: Tag mismatch\n"); */
		return -1;
	}

	return 0;
}


int aes_gmac(const u8 *key, size_t key_len, const u8 *iv, size_t iv_len,
	     const u8 *aad, size_t aad_len, u8 *tag)
{
	return aes_gcm_ae(key, key_len, iv, iv_len, NULL, 0, aad, aad_len, NULL,
			  tag);
}
