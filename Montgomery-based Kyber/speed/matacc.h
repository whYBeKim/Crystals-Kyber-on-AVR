#ifndef MATACC_H
#define MATACC_H
#include "poly.h"
#include "polyvec.h"
#include "symmetric.h"

void inner_matacc_asm_cache_16_32(int32_t* r, const poly* b, int16_t* b_prime, const int ctr, const uint16_t* coval, int index);
void inner_matacc_asm_cache_32_32(int32_t* r, const poly* b, int16_t* b_prime, const int ctr, const uint16_t* coval, int index);
void inner_matacc_asm_cache_32_16(poly* r, int32_t* r_temp, const poly* b, int16_t* b_prime, const int ctr, const uint16_t* coval, int index);
void inner_matacc_asm_opt_16_32(int32_t* r, const poly* b, const int16_t* b_prime, const int ctr, const uint16_t* coval, int index);
void inner_matacc_asm_opt_32_32(int32_t* r, const poly* b, const int16_t* b_prime, const int ctr, const uint16_t* coval, int index);
void inner_matacc_asm_opt_32_16(poly* r, int32_t* r_temp, const poly* b, const int16_t* b_prime, const int ctr, const uint16_t* coval, int index);

void matacc_cache_16_32(int32_t* r, const poly* b, int16_t* b_prime, xof_state* state, unsigned char* buf);
void matacc_cache_32_32(int32_t* r, const poly* b, int16_t* b_prime, xof_state* state, unsigned char* buf);
void matacc_cache_32_16(poly* r, int32_t* r_temp, const poly* b, int16_t* b_prime, xof_state* state, unsigned char* buf);
void matacc_opt_16_32(int32_t* r, const poly* b, const int16_t* b_prime, xof_state* state, unsigned char* buf);
void matacc_opt_32_32(int32_t* r, const poly* b, const int16_t* b_prime, xof_state* state, unsigned char* buf);
void matacc_opt_32_16(poly* r, int32_t* r_temp, const poly* b, const int16_t* b_prime, xof_state* state, unsigned char* buf);


void matacc_cache32(poly* r, const polyvec* b, int16_t(*b_prime)[KYBER_N / 2], unsigned char i, const unsigned char* seed, int transposed);
void matacc_opt32(poly* r, const polyvec* b, const int16_t (*b_prime)[KYBER_N / 2], unsigned char i, const unsigned char* seed, int transposed);
#endif