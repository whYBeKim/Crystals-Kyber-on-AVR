#ifndef POLY_H
#define POLY_H
#include "params.h"
#include <stdint.h>

/*
 * Elements of R_q = Z_q[X]/(X^n + 1). Represents polynomial
 * coeffs[0] + X*coeffs[1] + X^2*xoeffs[2] + ... + X^{n-1}*coeffs[n-1]
 */
typedef struct {
    int16_t coeffs[KYBER_N];
} poly;

void poly_packcompress(unsigned char* r, poly* a, int i);
void poly_unpackdecompress(poly* r, const unsigned char* a, int i);

void poly_compress(uint8_t r[KYBER_POLYCOMPRESSEDBYTES], poly *a);
void poly_decompress(poly *r, const uint8_t a[KYBER_POLYCOMPRESSEDBYTES]);

int cmp_poly_compress(const unsigned char* r, poly* a);
int cmp_poly_packcompress(const unsigned char* r, poly* a, int i);

void poly_tobytes(uint8_t r[KYBER_POLYBYTES], poly *a);
void poly_frombytes(poly *r, const uint8_t a[KYBER_POLYBYTES]);

void poly_frombytes_mul(poly* r, const poly* b, const unsigned char* a);
void poly_frombytes_mul_acc(poly* r, const poly* b, const unsigned char* a);

void poly_frommsg(poly *r, const uint8_t msg[KYBER_INDCPA_MSGBYTES]);
void poly_tomsg(uint8_t msg[KYBER_INDCPA_MSGBYTES], poly *a);

void poly_addnoise_eta1(poly* r, const uint8_t seed[KYBER_SYMBYTES], uint8_t nonce);
void poly_addnoise_eta2(poly* r, const uint8_t seed[KYBER_SYMBYTES], uint8_t nonce);

void poly_getnoise_eta1(poly *r, const uint8_t seed[KYBER_SYMBYTES], uint8_t nonce);
void poly_getnoise_eta2(poly *r, const uint8_t seed[KYBER_SYMBYTES], uint8_t nonce);

void poly_ntt(poly *r);
void poly_invntt(poly *r);
void poly_basemul_acc(poly* r, const poly* a, const poly* b);
void poly_basemul(poly *r, const poly *a, const poly *b);

void poly_reduce(poly *r);
void poly_csubq_asm(poly* r);

void poly_add(poly *r, const poly *a, const poly *b);
void poly_sub(poly *r, const poly *a, const poly *b);


#endif
