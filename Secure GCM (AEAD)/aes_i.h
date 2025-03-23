/*
 * AES (Rijndael) cipher
 * Copyright (c) 2003-2012, Jouni Malinen <j@w1.fi>
 *
 * This software may be distributed under the terms of the BSD license.
 * See README for more details.
 */

#ifndef AES_I_H
#define AES_I_H

#include "aes.h"

/* On the AVR we should store lookup tables in read-only flash memory,
   which is the only place large enough to hold them all on the Arduino Uno */
#ifdef __AVR
#include <avr/pgmspace.h>
#else
#define PROGMEM
#define pgm_read_dword(expr) (*(expr))
#endif

/* #define FULL_UNROLL */

extern const u32 Te0[256];
extern const u32 Td0[256];
extern const u8 Td4s[256];
extern const u8 rcons[10];

#define RCON(i) (pgm_read_dword(&rcons[(i)]) << 24)

static inline u32 rotr(u32 val, int bits)
{
	return (val >> bits) | (val << (32 - bits));
}

#define TE0(i) pgm_read_dword(&Te0[((i) >> 24) & 0xff])
#define TE1(i) rotr(pgm_read_dword(&Te0[((i) >> 16) & 0xff]), 8)
#define TE2(i) rotr(pgm_read_dword(&Te0[((i) >> 8) & 0xff]), 16)
#define TE3(i) rotr(pgm_read_dword(&Te0[(i) & 0xff]), 24)
#define TE41(i) ((pgm_read_dword(&Te0[((i) >> 24) & 0xff]) << 8) & 0xff000000)
#define TE42(i) (pgm_read_dword(&Te0[((i) >> 16) & 0xff]) & 0x00ff0000)
#define TE43(i) (pgm_read_dword(&Te0[((i) >> 8) & 0xff]) & 0x0000ff00)
#define TE44(i) ((pgm_read_dword(&Te0[(i) & 0xff]) >> 8) & 0x000000ff)
#define TE421(i) ((pgm_read_dword(&Te0[((i) >> 16) & 0xff]) << 8) & 0xff000000)
#define TE432(i) (pgm_read_dword(&Te0[((i) >> 8) & 0xff]) & 0x00ff0000)
#define TE443(i) (pgm_read_dword(&Te0[(i) & 0xff]) & 0x0000ff00)
#define TE414(i) ((pgm_read_dword(&Te0[((i) >> 24) & 0xff]) >> 8) & 0x000000ff)
#define TE411(i) ((pgm_read_dword(&Te0[((i) >> 24) & 0xff]) << 8) & 0xff000000)
#define TE422(i) (pgm_read_dword(&Te0[((i) >> 16) & 0xff]) & 0x00ff0000)
#define TE433(i) (pgm_read_dword(&Te0[((i) >> 8) & 0xff]) & 0x0000ff00)
#define TE444(i) ((pgm_read_dword(&Te0[(i) & 0xff]) >> 8) & 0x000000ff)
#define TE4(i) ((pgm_read_dword(&Te0[(i)]) >> 8) & 0x000000ff)

#define TD0(i) pgm_read_dword(&Td0[((i) >> 24) & 0xff])
#define TD1(i) rotr(pgm_read_dword(&Td0[((i) >> 16) & 0xff]), 8)
#define TD2(i) rotr(pgm_read_dword(&Td0[((i) >> 8) & 0xff]), 16)
#define TD3(i) rotr(pgm_read_dword(&Td0[(i) & 0xff]), 24)
#define TD41(i) (pgm_read_dword(&Td4s[((i) >> 24) & 0xff]) << 24)
#define TD42(i) (pgm_read_dword(&Td4s[((i) >> 16) & 0xff]) << 16)
#define TD43(i) (pgm_read_dword(&Td4s[((i) >> 8) & 0xff]) << 8)
#define TD44(i) (pgm_read_dword(&Td4s[(i) & 0xff]))
#define TD0_(i) pgm_read_dword(&Td0[(i) & 0xff])
#define TD1_(i) rotr(pgm_read_dword(&Td0[(i) & 0xff]), 8)
#define TD2_(i) rotr(pgm_read_dword(&Td0[(i) & 0xff]), 16)
#define TD3_(i) rotr(pgm_read_dword(&Td0[(i) & 0xff]), 24)

#define GETU32(pt) (((u32)(pt)[0] << 24) ^ ((u32)(pt)[1] << 16) ^ \
((u32)(pt)[2] <<  8) ^ ((u32)(pt)[3]))
#define PUTU32(ct, st) { \
(ct)[0] = (u8)((st) >> 24); (ct)[1] = (u8)((st) >> 16); \
(ct)[2] = (u8)((st) >>  8); (ct)[3] = (u8)(st); }

#define AES_PRIV_SIZE (4 * 4 * 15 + 4)
#define AES_PRIV_NR_POS (4 * 15)

int rijndaelKeySetupEnc(u32 rk[], const u8 cipherKey[], int keyBits);

#endif /* AES_I_H */
