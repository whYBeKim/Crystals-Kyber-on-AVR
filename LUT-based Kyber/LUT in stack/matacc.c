#include "indcpa.h"
#include "ntt.h"
#include "params.h"
#include "randombytes.h"
#include "symmetric.h"
#include <stddef.h>
#include "reduce.h"

static void inner_matacc(poly* res, poly* src, const int ctr, const int16_t* coval, int16_t zeta)
{
	int16_t r[4];
	basemul_asm(&r[0], &coval[0], &src->coeffs[ctr - 4], zeta);
	basemul_asm(&r[2], &coval[2], &src->coeffs[ctr - 2], -zeta);

	res->coeffs[ctr - 4] += r[0];
	res->coeffs[ctr - 3] += r[1];
	res->coeffs[ctr - 2] += r[2];
	res->coeffs[ctr - 1] += r[3];
}


/*************************************************
* Name:        matacc
*
* Description: Multiplies a row of A or A^T, generated on-the-fly,
*              with a vector of polynomials and accumulates into the result.
*
* Arguments:   - poly *r:                    pointer to output polynomial to accumulate in
*              - polyvec *b:                 pointer to input vector of polynomials to multiply with
*              - unsigned char i:            byte to indicate the index < KYBER_K of the row of A or A^T
*              - const unsigned char *seed:  pointer to the public seed used to generate A
*              - int transposed:             boolean indicatin whether A or A^T is generated
**************************************************/
void matacc(poly* res, polyvec* src, unsigned char i, const unsigned char* seed, int transposed)
{
	unsigned char buf[XOF_BLOCKBYTES + 1];
	xof_state state;
	int ctr = 0, pos = 0, k = 0;
	uint16_t val0, val1;
	int16_t coval[4];

	for (int j = 0; j < KYBER_N; j++)
	{
		res->coeffs[j] = 0x00;
	}

	for (int j = 0; j < KYBER_K; j++)
	{
		ctr = pos = 0;
		if (transposed)
			xof_absorb(&state, seed, i, j);
		else
			xof_absorb(&state, seed, j, i);

		xof_squeezeblocks(buf, 1, &state);

		while (ctr < KYBER_N)
		{

			val0 = ((buf[pos + 0] >> 0) | ((uint16_t)buf[pos + 1] << 8)) & 0xFFF;
			val1 = ((buf[pos + 1] >> 4) | ((uint16_t)buf[pos + 2] << 4)) & 0xFFF;
			pos += 3;

			if (val0 < KYBER_Q) {
				coval[k++] = val0;
				ctr++;
				if (k == 4)
				{
					inner_matacc(res, &src->vec[j], ctr, coval, ntt_zetas[(ctr >> 2) - 1]);
					k = 0;
				}
			}

			if ((ctr < KYBER_N) && (val1 < KYBER_Q)) {
				coval[k++] = val1;
				ctr++;
				if (k == 4)
				{
					inner_matacc(res, &src->vec[j], ctr, coval, ntt_zetas[(ctr >> 2) - 1]);
					k = 0;
				}
			}

			if (pos + 3 > XOF_BLOCKBYTES) {
				xof_squeezeblocks(buf, 1, &state);
				pos = 0;
			}
		}
		poly_reduce(res);
	}
}