/*
 * GccApplication1.c
 *
 * Created: 2023-03-18 오후 12:07:09
 */ 
#include "ntt.h"
#include <avr/io.h>
#include "api.h"

uint8_t pk[CRYPTO_PUBLICKEYBYTES] = {0};
uint8_t ct[CRYPTO_CIPHERTEXTBYTES] = {0};

void test()
{
	uint8_t sk[CRYPTO_SECRETKEYBYTES] = {0};
	uint8_t ss[CRYPTO_BYTES] = {0};
	
	int ret = 0;
	
	//ret = crypto_kem_keypair(pk, sk);
	ret = crypto_kem_enc(ct, ss, pk);
    ret = crypto_kem_dec(ss, ct, sk);
	
}

int main()
{
	
	test();
	return 0 ;
}
