#ifndef NTT_H
#define NTT_H
#include "params.h"
#include <stdint.h>

/* Code to generate zetas and zetas_inv used in the number-theoretic transform:

#define KYBER_ROOT_OF_UNITY 17

static const uint8_t tree[128] = {
  0, 64, 32, 96, 16, 80, 48, 112, 8, 72, 40, 104, 24, 88, 56, 120,
  4, 68, 36, 100, 20, 84, 52, 116, 12, 76, 44, 108, 28, 92, 60, 124,
  2, 66, 34, 98, 18, 82, 50, 114, 10, 74, 42, 106, 26, 90, 58, 122,
  6, 70, 38, 102, 22, 86, 54, 118, 14, 78, 46, 110, 30, 94, 62, 126,
  1, 65, 33, 97, 17, 81, 49, 113, 9, 73, 41, 105, 25, 89, 57, 121,
  5, 69, 37, 101, 21, 85, 53, 117, 13, 77, 45, 109, 29, 93, 61, 125,
  3, 67, 35, 99, 19, 83, 51, 115, 11, 75, 43, 107, 27, 91, 59, 123,
  7, 71, 39, 103, 23, 87, 55, 119, 15, 79, 47, 111, 31, 95, 63, 127
};

void init_ntt()
{
	unsigned int i;
	int16_t tmp[128];
	int16_t no_montgomery_zetas[128] = { 0 };
	tmp[0] = 1;
	for (i = 1; i < 128; i++)
	tmp[i] = (tmp[i - 1] * KYBER_ROOT_OF_UNITY) % KYBER_Q;
	for (i = 0; i < 128; i++) {
		no_montgomery_zetas[i] = tmp[tree[i]];
	}

	for (int cnt_i = 0; cnt_i < 128; cnt_i++)
	{
		if ((cnt_i != 0) && (cnt_i % 8 == 0))
		{
			printf("\n");
		}
		if (no_montgomery_zetas[cnt_i] < 0)
		{
			printf("%d, ", no_montgomery_zetas[cnt_i] + KYBER_Q);
		}
		else
		{
			printf("%d, ", no_montgomery_zetas[cnt_i]);
		}
	}
	printf("\n");
}
*/

const int16_t ntt_zetas[64];
extern void LUT_ntt_asm (int16_t r[256]);
extern void LUT_invntt_asm (int16_t r[256]);
extern void basemul_asm (int16_t r[2], const int16_t a[2], const int16_t b[2], int16_t zeta);

#endif
