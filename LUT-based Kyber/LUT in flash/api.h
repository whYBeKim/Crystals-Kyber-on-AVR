#ifndef API_H
#define API_H

#include <stdint.h>
#include "params.h"

#define CRYPTO_SECRETKEYBYTES  KYBER_SECRETKEYBYTES
#define CRYPTO_PUBLICKEYBYTES  KYBER_PUBLICKEYBYTES
#define CRYPTO_CIPHERTEXTBYTES KYBER_CIPHERTEXTBYTES
#define CRYPTO_BYTES           KYBER_SSBYTES

int crypto_kem_keypair(uint8_t* pk, uint8_t* sk);

int crypto_kem_enc(uint8_t* ct, uint8_t* ss, const uint8_t* pk);

int crypto_kem_dec(uint8_t* ss, const uint8_t* ct, const uint8_t* sk);

#endif
