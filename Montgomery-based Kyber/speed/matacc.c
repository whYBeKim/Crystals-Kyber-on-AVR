#include "indcpa.h"
#include "ntt.h"
#include "params.h"
#include "randombytes.h"
#include "symmetric.h"
#include <stddef.h>
#include "reduce.h"

void inner_matacc_asm_cache_16_32(int32_t* r, const poly* b, int16_t* b_prime, const int ctr, const int16_t* coval, int index)
{
	int32_t r_temp[2];
	b_prime[index << 1] = montgomery_reduce((int32_t)b->coeffs[ctr - 3] * zetas[64 + index]);
	r_temp[0] = ((int32_t)coval[1] * b_prime[index << 1]);
	r_temp[0] += ((int32_t)coval[0] * b->coeffs[ctr - 4]);
	r_temp[1] = ((int32_t)coval[0] * b->coeffs[ctr - 3]);
	r_temp[1] += ((int32_t)coval[1] * b->coeffs[ctr - 4]);

	r[ctr - 4] = r_temp[0];
	r[ctr - 3] = r_temp[1];

	b_prime[(index << 1) + 1] = montgomery_reduce((int32_t)b->coeffs[ctr - 1] * (-zetas[64 + index]));
	r_temp[0] = ((int32_t)coval[3] * b_prime[(index << 1) + 1]);
	r_temp[0] += ((int32_t)coval[2] * b->coeffs[ctr - 2]);
	r_temp[1] = ((int32_t)coval[2] * b->coeffs[ctr - 1]);
	r_temp[1] += ((int32_t)coval[3] * b->coeffs[ctr - 2]);

	r[ctr - 2] = r_temp[0];
	r[ctr - 1] = r_temp[1];
}

void matacc_cache_16_32(int32_t* r, const poly* b, int16_t* b_prime, xof_state* state, unsigned char* buf)
{
	uint16_t val0, val1;
	int16_t coval[4];
	int ctr = 0, pos = 0, k = 0, index = 0;

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
				inner_matacc_asm_cache_16_32(r, b, b_prime, ctr, coval, index);
				index += 1;
				k = 0;
			}
		}

		if ((ctr < KYBER_N) && (val1 < KYBER_Q)) {
			coval[k++] = val1;
			ctr++;
			if (k == 4)
			{
				inner_matacc_asm_cache_16_32(r, b, b_prime, ctr, coval, index);
				index += 1;
				k = 0;
			}
		}

		if (pos + 3 > XOF_BLOCKBYTES) {
			xof_squeezeblocks(buf, 1, state);
			pos = 0;
		}
	}
}


void inner_matacc_asm_cache_32_32(int32_t* r, const poly* b, int16_t* b_prime, const int ctr, const int16_t* coval, int index)
{

	int32_t r_temp[2];
	b_prime[index << 1] = montgomery_reduce((int32_t)b->coeffs[ctr - 3] * zetas[64+index]);
	r_temp[0] = ((int32_t)coval[1] * b_prime[index << 1]);
	r_temp[0] += ((int32_t)coval[0] * b->coeffs[ctr - 4]);
	r_temp[1] = ((int32_t)coval[0] * b->coeffs[ctr - 3]);
	r_temp[1] += ((int32_t)coval[1] * b->coeffs[ctr - 4]);

	r[ctr - 4] += r_temp[0];
	r[ctr - 3] += r_temp[1];

	b_prime[(index << 1) + 1] = montgomery_reduce((int32_t)b->coeffs[ctr - 1] * (-zetas[64+index]));
	r_temp[0] = ((int32_t)coval[3] * b_prime[(index << 1) + 1]);
	r_temp[0] += ((int32_t)coval[2] * b->coeffs[ctr - 2]);
	r_temp[1] = ((int32_t)coval[2] * b->coeffs[ctr - 1]);
	r_temp[1] += ((int32_t)coval[3] * b->coeffs[ctr - 2]);

	r[ctr - 2] += r_temp[0];
	r[ctr - 1] += r_temp[1];
}

void matacc_cache_32_32(int32_t* r, const poly* b, int16_t* b_prime, xof_state* state, unsigned char* buf)
{
	uint16_t val0, val1;
	int16_t coval[4];
	int ctr = 0, pos = 0, k = 0, index = 0;

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
				inner_matacc_asm_cache_32_32(r, b, b_prime, ctr, coval, index);
				index += 1;
				k = 0;
			}
		}

		if ((ctr < KYBER_N) && (val1 < KYBER_Q)) {
			coval[k++] = val1;
			ctr++;
			if (k == 4)
			{
				inner_matacc_asm_cache_32_32(r, b, b_prime, ctr, coval, index);
				index += 1;
				k = 0;
			}
		}

		if (pos + 3 > XOF_BLOCKBYTES) {
			xof_squeezeblocks(buf, 1, state);
			pos = 0;
		}
	}
}

void inner_matacc_asm_cache_32_16(poly* r, int32_t* r_temp, const poly* b, int16_t* b_prime, const int ctr, const int16_t* coval, int index)
{

	int32_t res[2];
	b_prime[index << 1] = montgomery_reduce((int32_t)b->coeffs[ctr - 3] * zetas[64+index]);
	res[0] = ((int32_t)coval[1] * b_prime[index << 1]);
	res[0] += ((int32_t)coval[0] * b->coeffs[ctr - 4]);
	res[1] = ((int32_t)coval[0] * b->coeffs[ctr - 3]);
	res[1] += ((int32_t)coval[1] * b->coeffs[ctr - 4]);
	r_temp[ctr - 4] += res[0];
	r_temp[ctr - 3] += res[1];
	r->coeffs[ctr - 4] = montgomery_reduce(r_temp[ctr - 4]);
	r->coeffs[ctr - 3] = montgomery_reduce(r_temp[ctr - 3]);
	r->coeffs[ctr - 4] = barrett_reduce(r->coeffs[ctr - 4]);
	r->coeffs[ctr - 3] = barrett_reduce(r->coeffs[ctr - 3]);

	b_prime[(index << 1) + 1] = montgomery_reduce((int32_t)b->coeffs[ctr - 1] * (-zetas[64+index]));
	res[0] = ((int32_t)coval[3] * b_prime[(index << 1) + 1]);
	res[0] += ((int32_t)coval[2] * b->coeffs[ctr - 2]);
	res[1] = ((int32_t)coval[2] * b->coeffs[ctr - 1]);
	res[1] += ((int32_t)coval[3] * b->coeffs[ctr - 2]);
	r_temp[ctr - 2] += res[0];
	r_temp[ctr - 1] += res[1];
	r->coeffs[ctr - 2] = montgomery_reduce(r_temp[ctr - 2]);
	r->coeffs[ctr - 1] = montgomery_reduce(r_temp[ctr - 1]);
	r->coeffs[ctr - 2] = barrett_reduce(r->coeffs[ctr - 2]);
	r->coeffs[ctr - 1] = barrett_reduce(r->coeffs[ctr - 1]);
}

void matacc_cache_32_16(poly* r, int32_t* r_temp, const poly* b, int16_t* b_prime, xof_state* state, unsigned char* buf)
{
	uint16_t val0, val1;
	int16_t coval[4];
	int ctr = 0, pos = 0, k = 0, index = 0;

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
				inner_matacc_asm_cache_32_16(r, r_temp, b, b_prime, ctr, coval, index);
				index += 1;
				k = 0;
			}
		}

		if ((ctr < KYBER_N) && (val1 < KYBER_Q)) {
			coval[k++] = val1;
			ctr++;
			if (k == 4)
			{
				inner_matacc_asm_cache_32_16(r, r_temp, b, b_prime, ctr, coval, index);
				index += 1;
				k = 0;
			}
		}

		if (pos + 3 > XOF_BLOCKBYTES) {
			xof_squeezeblocks(buf, 1, state);
			pos = 0;
		}
	}
}

/*************************************************
* Name:        matacc_cache32
*
* Description: Multiplies a row of A or A^T, generated on-the-fly,
*              with a vector of polynomials and accumulates into the result.
*              Using asymmetric multiplication and better accumulation.
*
* Arguments:   - poly *r:                    pointer to output polynomial to accumulate in
*              - const polyvec *b:           pointer to input vector of polynomials to multiply with
*              - polyvec *b_prime:           pointer to output vector of polynomials to store b multiplied by zetas
*              - unsigned char i:            byte to indicate the index < KYBER_K of the row of A or A^T
*              - const unsigned char *seed:  pointer to the public seed used to generate A
*              - int transposed:             boolean indicatin whether A or A^T is generated
**************************************************/
void matacc_cache32(poly* r, const polyvec* b, int16_t(*b_prime)[KYBER_N / 2], unsigned char i, const unsigned char* seed, int transposed)
{
	unsigned char buf[XOF_BLOCKBYTES + 1];
	xof_state state;
	int32_t r_temp[KYBER_N];
	int j = 0;

	if (transposed)
		xof_absorb(&state, seed, i, j);
	else
		xof_absorb(&state, seed, j, i);

	xof_squeezeblocks(buf, 1, &state);

	matacc_cache_16_32(r_temp, &b->vec[j], *(b_prime + j), &state, buf);

	for (j = 1; j < KYBER_K - 1; j++)
	{
		if (transposed)
			xof_absorb(&state, seed, i, j);
		else
			xof_absorb(&state, seed, j, i);

		xof_squeezeblocks(buf, 1, &state);

		matacc_cache_32_32(r_temp, &b->vec[j], *(b_prime + j), &state, buf);
	}

	if (transposed)
		xof_absorb(&state, seed, i, j);
	else
		xof_absorb(&state, seed, j, i);

	xof_squeezeblocks(buf, 1, &state);

	matacc_cache_32_16(r, r_temp, &b->vec[j], *(b_prime + j), &state, buf);
}

void inner_matacc_asm_opt_16_32(int32_t* r, const poly* b, const int16_t* b_prime, const int ctr, const int16_t* coval, int index)
{

	r[ctr - 4] = ((int32_t)coval[1] * b_prime[index << 1]);
	r[ctr - 4] += ((int32_t)coval[0] * b->coeffs[ctr - 4]);
	r[ctr - 3] = ((int32_t)coval[0] * b->coeffs[ctr - 3]);
	r[ctr - 3] += ((int32_t)coval[1] * b->coeffs[ctr - 4]);

	r[ctr - 2] = ((int32_t)coval[3] * b_prime[(index << 1) + 1]);
	r[ctr - 2] += ((int32_t)coval[2] * b->coeffs[ctr - 2]);
	r[ctr - 1] = ((int32_t)coval[2] * b->coeffs[ctr - 1]);
	r[ctr - 1] += ((int32_t)coval[3] * b->coeffs[ctr - 2]);

}

void matacc_opt_16_32(int32_t* r, const poly* b, const int16_t* b_prime, xof_state* state, unsigned char* buf)
{
	uint16_t val0, val1;
	int16_t coval[4];
	int ctr = 0, pos = 0, k = 0, index = 0;

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
				inner_matacc_asm_opt_16_32(r, b, b_prime, ctr, coval, index);
				index += 1;
				k = 0;
			}
		}

		if ((ctr < KYBER_N) && (val1 < KYBER_Q)) {
			coval[k++] = val1;
			ctr++;
			if (k == 4)
			{
				inner_matacc_asm_opt_16_32(r, b, b_prime, ctr, coval, index);
				index += 1;
				k = 0;
			}
		}

		if (pos + 3 > XOF_BLOCKBYTES) {
			xof_squeezeblocks(buf, 1, state);
			pos = 0;
		}
	}
}


void inner_matacc_asm_opt_32_32(int32_t* r, const poly* b, const int16_t* b_prime, const int ctr, const int16_t* coval, int index)
{

	int32_t r_temp[2];
	r_temp[0] = ((int32_t)coval[1] * b_prime[index << 1]);
	r_temp[0] += ((int32_t)coval[0] * b->coeffs[ctr - 4]);
	r_temp[1] = ((int32_t)coval[0] * b->coeffs[ctr - 3]);
	r_temp[1] += ((int32_t)coval[1] * b->coeffs[ctr - 4]);

	r[ctr - 4] += r_temp[0];
	r[ctr - 3] += r_temp[1];

	r_temp[0] = ((int32_t)coval[3] * b_prime[(index << 1) + 1]);
	r_temp[0] += ((int32_t)coval[2] * b->coeffs[ctr - 2]);
	r_temp[1] = ((int32_t)coval[2] * b->coeffs[ctr - 1]);
	r_temp[1] += ((int32_t)coval[3] * b->coeffs[ctr - 2]);

	r[ctr - 2] += r_temp[0];
	r[ctr - 1] += r_temp[1];
}

void matacc_opt_32_32(int32_t* r, const poly* b, const int16_t* b_prime, xof_state* state, unsigned char* buf)
{
	uint16_t val0, val1;
	int16_t coval[4];
	int ctr = 0, pos = 0, k = 0, index = 0;

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
				inner_matacc_asm_opt_32_32(r, b, b_prime, ctr, coval, index);
				index += 1;
				k = 0;
			}
		}

		if ((ctr < KYBER_N) && (val1 < KYBER_Q)) {
			coval[k++] = val1;
			ctr++;
			if (k == 4)
			{
				inner_matacc_asm_opt_32_32(r, b, b_prime, ctr, coval, index);
				index += 1;
				k = 0;
			}
		}

		if (pos + 3 > XOF_BLOCKBYTES) {
			xof_squeezeblocks(buf, 1, state);
			pos = 0;
		}
	}
}

void inner_matacc_asm_opt_32_16(poly* r, int32_t* r_temp, const poly* b, const int16_t* b_prime, const int ctr, const int16_t* coval, int index)
{

	int32_t res[2];
	int16_t mont_res[2];
	
	res[0] = ((int32_t)coval[1] * b_prime[index << 1]);
	res[0] += ((int32_t)coval[0] * b->coeffs[ctr - 4]);
	res[1] = ((int32_t)coval[0] * b->coeffs[ctr - 3]);
	res[1] += ((int32_t)coval[1] * b->coeffs[ctr - 4]);
	r_temp[ctr - 4] += res[0];
	r_temp[ctr - 3] += res[1];
	mont_res[0] = montgomery_reduce(r_temp[ctr - 4]);
	mont_res[1] = montgomery_reduce(r_temp[ctr - 3]);
	r->coeffs[ctr - 4] = barrett_reduce(mont_res[0]);
	r->coeffs[ctr - 3] = barrett_reduce(mont_res[1]);

	res[0] = ((int32_t)coval[3] * b_prime[(index << 1) + 1]);
	res[0] += ((int32_t)coval[2] * b->coeffs[ctr - 2]);
	res[1] = ((int32_t)coval[2] * b->coeffs[ctr - 1]);
	res[1] += ((int32_t)coval[3] * b->coeffs[ctr - 2]);
	r_temp[ctr - 2] += res[0];
	r_temp[ctr - 1] += res[1];
	mont_res[0] = montgomery_reduce(r_temp[ctr - 2]);
	mont_res[1] = montgomery_reduce(r_temp[ctr - 1]);
	r->coeffs[ctr - 2] = barrett_reduce(mont_res[0]);
	r->coeffs[ctr - 1] = barrett_reduce(mont_res[1]);
}

void matacc_opt_32_16(poly* r, int32_t* r_temp, const poly* b, const int16_t* b_prime, xof_state* state, unsigned char* buf)
{
	uint16_t val0, val1;
	int16_t coval[4];
	int ctr = 0, pos = 0, k = 0, index = 0;

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
				inner_matacc_asm_opt_32_16(r, r_temp, b, b_prime, ctr, coval, index);
				index += 1;
				k = 0;
			}
		}

		if ((ctr < KYBER_N) && (val1 < KYBER_Q)) {
			coval[k++] = val1;
			ctr++;
			if (k == 4)
			{
				inner_matacc_asm_opt_32_16(r, r_temp, b, b_prime, ctr, coval, index);
				index += 1;
				k = 0;
			}
		}

		if (pos + 3 > XOF_BLOCKBYTES) {
			xof_squeezeblocks(buf, 1, state);
			pos = 0;
		}
	}
}
/*************************************************
* Name:        matacc_opt32
*
* Description: Multiplies a row of A or A^T, generated on-the-fly,
*              with a vector of polynomials and accumulates into the result.
*              Using asymmetric multiplication and better accumulation.
*
* Arguments:   - poly *r:                    pointer to output polynomial to accumulate in
*              - const polyvec *b:           pointer to input vector of polynomials to multiply with
*              - polyvec *b_prime:           pointer to output vector of polynomials to store b multiplied by zetas
*              - unsigned char i:            byte to indicate the index < KYBER_K of the row of A or A^T
*              - const unsigned char *seed:  pointer to the public seed used to generate A
*              - int transposed:             boolean indicatin whether A or A^T is generated
**************************************************/
void matacc_opt32(poly* r, const polyvec* b, const int16_t(*b_prime)[KYBER_N / 2], unsigned char i, const unsigned char* seed, int transposed)
{
	unsigned char buf[XOF_BLOCKBYTES + 1];
	xof_state state;
	int32_t r_temp[KYBER_N];
	int j = 0;

	if (transposed)
		xof_absorb(&state, seed, i, j);
	else
		xof_absorb(&state, seed, j, i);

	xof_squeezeblocks(buf, 1, &state);

	matacc_opt_16_32(r_temp, &b->vec[j], *(b_prime + j), &state, buf);

	for (j = 1; j < KYBER_K - 1; j++)
	{
		if (transposed)
			xof_absorb(&state, seed, i, j);
		else
			xof_absorb(&state, seed, j, i);

		xof_squeezeblocks(buf, 1, &state);

		matacc_opt_32_32(r_temp, &b->vec[j], *(b_prime + j), &state, buf);
	}

	if (transposed)
		xof_absorb(&state, seed, i, j);
	else
		xof_absorb(&state, seed, j, i);

	xof_squeezeblocks(buf, 1, &state);

	matacc_opt_32_16(r, r_temp, &b->vec[j], *(b_prime + j), &state, buf);
}
