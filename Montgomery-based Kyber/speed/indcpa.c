#include "indcpa.h"
#include "ntt.h"
#include "params.h"
#include "poly.h"
#include "polyvec.h"
#include "randombytes.h"
#include "symmetric.h"
#include "matacc.h"
#include <stddef.h>
#include <string.h>
#include "reduce.h"


polyvec sp;
poly bp;
/*************************************************
* Name:        indcpa_keypair
*
* Description: Generates public and private key for the CPA-secure
*              public-key encryption scheme underlying Kyber
*
* Arguments:   - uint8_t *pk: pointer to output public key
*                             (of length KYBER_INDCPA_PUBLICKEYBYTES bytes)
*              - uint8_t *sk: pointer to output private key
							  (of length KYBER_INDCPA_SECRETKEYBYTES bytes)
**************************************************/
void indcpa_keypair(uint8_t pk[KYBER_INDCPA_PUBLICKEYBYTES],
	uint8_t sk[KYBER_INDCPA_SECRETKEYBYTES])
{
	unsigned int i;
	uint8_t buf[2 * KYBER_SYMBYTES];
	const uint8_t* publicseed = buf;
	const uint8_t* noiseseed = buf + KYBER_SYMBYTES;
	uint8_t nonce = 0;
	poly pkp;
	int16_t skpv_prime[KYBER_K][KYBER_N / 2];

	randombytes(buf, KYBER_SYMBYTES);
	hash_g(buf, buf, KYBER_SYMBYTES);

	for (i = 0; i < KYBER_K; i++)
	{
		poly_getnoise_eta1(&sp.vec[i], noiseseed, nonce++);
	}
	polyvec_ntt(&sp);

	//i = 0
	matacc_cache32(&pkp, &sp, skpv_prime, 0, publicseed, 0);
	poly_invntt_tomont(&pkp);
	poly_addnoise_eta1(&pkp, noiseseed, nonce++);
	poly_ntt(&pkp);
	poly_tobytes(pk, &pkp);

	for (i = 1; i < KYBER_K; i++)
	{
		matacc_opt32(&pkp, &sp, skpv_prime, i, publicseed, 0);
		poly_invntt_tomont(&pkp);
		poly_addnoise_eta1(&pkp, noiseseed, nonce++);
		poly_ntt(&pkp);
		poly_tobytes(pk + i * KYBER_POLYBYTES, &pkp);
	}

	polyvec_tobytes(sk, &sp);
	memcpy(pk + KYBER_POLYVECBYTES, publicseed, KYBER_SYMBYTES);
}

/*************************************************
* Name:        indcpa_enc
*
* Description: Encryption function of the CPA-secure
*              public-key encryption scheme underlying Kyber.
*
* Arguments:   - uint8_t *c: pointer to output ciphertext
*                            (of length KYBER_INDCPA_BYTES bytes)
*              - const uint8_t *m: pointer to input message
*                                  (of length KYBER_INDCPA_MSGBYTES bytes)
*              - const uint8_t *pk: pointer to input public key
*                                   (of length KYBER_INDCPA_PUBLICKEYBYTES)
*              - const uint8_t *coins: pointer to input random coins used as seed
*                                      (of length KYBER_SYMBYTES) to deterministically
*                                      generate all randomness
**************************************************/


void indcpa_enc(uint8_t c[KYBER_INDCPA_BYTES],
	const uint8_t m[KYBER_INDCPA_MSGBYTES],
	const uint8_t pk[KYBER_INDCPA_PUBLICKEYBYTES],
	const uint8_t coins[KYBER_SYMBYTES]) 
{
	unsigned int i;
	poly* pkp = &bp;
	poly* k = &bp;
	poly* v = &sp.vec[0];
	int16_t sp_prime[KYBER_K][KYBER_N / 2];
	const unsigned char* seed = pk + KYBER_POLYVECBYTES;
	unsigned char nonce = 0;

	for (i = 0; i < KYBER_K; i++)
		poly_getnoise_eta1(sp.vec + i, coins, nonce++);

	polyvec_ntt(&sp);

	// i = 0
	matacc_cache32(&bp, &sp, sp_prime, 0, seed, 1);
	poly_invntt_tomont(&bp);
	poly_addnoise_eta2(&bp, coins, nonce++);
	poly_reduce(&bp);
	poly_packcompress(c, &bp, 0);

	for (i = 1; i < KYBER_K; i++) {
		matacc_opt32(&bp, &sp, sp_prime, i, seed, 1);
		poly_invntt_tomont(&bp);
		poly_addnoise_eta2(&bp, coins, nonce++);
		poly_reduce(&bp);
		poly_packcompress(c, &bp, i);
	}
	poly_frombytes(pkp, pk);

	int32_t v_temp[KYBER_N];

	poly_basemul_opt_16_32(v_temp, pkp, &sp.vec[0], *(sp_prime + 0));
	for (i = 1; i < KYBER_K - 1; i++) {
		poly_frombytes(pkp, pk + i * KYBER_POLYBYTES);
		poly_basemul_opt_32_32(v_temp, pkp, &sp.vec[i], *(sp_prime + i));
	}
	poly_frombytes(pkp, pk + i * KYBER_POLYBYTES);
	poly_basemul_opt_32_16(v, v_temp, pkp, &sp.vec[i], *(sp_prime + i));

	poly_invntt_tomont(v);
	poly_addnoise_eta2(v, coins, nonce++);
	poly_frommsg(k, m);
	poly_add(v, v, k);
	poly_reduce(v);
	poly_compress(c + KYBER_POLYVECCOMPRESSEDBYTES, v);
}

/*************************************************
* Name:        indcpa_enc_cmp
*
* Description: Re-encryption function.
*              Compares the re-encypted ciphertext with the original ciphertext byte per byte.
*              The comparison is performed in a constant time manner.
*
*
* Arguments:   - unsigned char *ct:         pointer to input ciphertext to compare the new ciphertext with (of length KYBER_INDCPA_BYTES bytes)
*              - const unsigned char *m:    pointer to input message (of length KYBER_INDCPA_MSGBYTES bytes)
*              - const unsigned char *pk:   pointer to input public key (of length KYBER_INDCPA_PUBLICKEYBYTES bytes)
*              - const unsigned char *coin: pointer to input random coins used as seed (of length KYBER_SYMBYTES bytes)
*                                           to deterministically generate all randomness
* Returns:     - boolean byte indicating that re-encrypted ciphertext is NOT equal to the original ciphertext
**************************************************/
unsigned char indcpa_enc_cmp(const unsigned char* c,
	const unsigned char* m,
	const unsigned char* pk,
	const unsigned char* coins) {

	uint64_t rc = 0;
	unsigned int i;
	poly* pkp = &bp;
	poly* k = &bp;
	poly* v = &sp.vec[0];
	int16_t sp_prime[KYBER_K][KYBER_N / 2];
	const unsigned char* seed = pk + KYBER_POLYVECBYTES;
	unsigned char nonce = 0;

	for (i = 0; i < KYBER_K; i++)
		poly_getnoise_eta1(sp.vec + i, coins, nonce++);

	polyvec_ntt(&sp);

	// i = 0
	matacc_cache32(&bp, &sp, sp_prime, 0, seed, 1);
	poly_invntt_tomont(&bp);
	poly_addnoise_eta2(&bp, coins, nonce++);
	poly_reduce(&bp);
	rc |= cmp_poly_packcompress(c, &bp, 0);

	for (i = 1; i < KYBER_K; i++) {
		matacc_opt32(&bp, &sp, sp_prime, i, seed, 1);
		poly_invntt_tomont(&bp);
		poly_addnoise_eta2(&bp, coins, nonce++);
		poly_reduce(&bp);
		rc |= cmp_poly_packcompress(c, &bp, i);
	}
	poly_frombytes(pkp, pk);

	int32_t v_temp[KYBER_N];

	poly_basemul_opt_16_32(v_temp, pkp, &sp.vec[0], *(sp_prime + 0));
	for (i = 1; i < KYBER_K - 1; i++) {
		poly_frombytes(pkp, pk + i * KYBER_POLYBYTES);
		poly_basemul_opt_32_32(v_temp, pkp, &sp.vec[i], *(sp_prime + i));
	}
	poly_frombytes(pkp, pk + i * KYBER_POLYBYTES);
	poly_basemul_opt_32_16(v, v_temp, pkp, &sp.vec[i], *(sp_prime + i));

	poly_invntt_tomont(v);
	poly_addnoise_eta2(v, coins, nonce++);
	poly_frommsg(k, m);
	poly_add(v, v, k);
	poly_reduce(v);

	rc |= cmp_poly_compress(c + KYBER_POLYVECCOMPRESSEDBYTES, v);

	rc = ~rc + 1;
	rc >>= 63;
	return (unsigned char)rc;
}

/*************************************************
* Name:        indcpa_dec
*
* Description: Decryption function of the CPA-secure
*              public-key encryption scheme underlying Kyber.
*
* Arguments:   - uint8_t *m: pointer to output decrypted message
*                            (of length KYBER_INDCPA_MSGBYTES)
*              - const uint8_t *c: pointer to input ciphertext
*                                  (of length KYBER_INDCPA_BYTES)
*              - const uint8_t *sk: pointer to input secret key
*                                   (of length KYBER_INDCPA_SECRETKEYBYTES)
**************************************************/

void indcpa_dec(uint8_t m[KYBER_INDCPA_MSGBYTES],
	const uint8_t c[KYBER_INDCPA_BYTES],
	const uint8_t sk[KYBER_INDCPA_SECRETKEYBYTES]) 
{

	poly mp;
	poly* v = &bp;
	int32_t r_temp[KYBER_N];
	int i;

	poly_unpackdecompress(&mp, c, 0);
	poly_ntt(&mp);
	poly_frombytes_mul_16_32(r_temp, &mp, sk);
	for (i = 1; i < KYBER_K - 1; i++) {
		poly_unpackdecompress(&bp, c, i);
		poly_ntt(&bp);
		poly_frombytes_mul_32_32(r_temp, &bp, sk + i * KYBER_POLYBYTES);
	}
	poly_unpackdecompress(&bp, c, i);
	poly_ntt(&bp);
	poly_frombytes_mul_32_16(&mp, r_temp, &bp, sk + i * KYBER_POLYBYTES);

	poly_invntt_tomont(&mp);
	poly_decompress(v, c + KYBER_POLYVECCOMPRESSEDBYTES);
	poly_sub(&mp, v, &mp);
	poly_reduce(&mp);
	
	poly_tomsg(m, &mp);

}
