#ifndef RANDOMBYTES_H
#define RANDOMBYTES_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

#ifdef _WIN32
	/* Load size_t on windows */
#include <crtdefs.h>
#else
#include <unistd.h>
#endif /* _WIN32 */


	/*
	 * Write `n` bytes of high quality random bytes to `buf`
	 */
	int randombytes(uint8_t* output, size_t n);

#ifdef __cplusplus
}
#endif

#endif /* RANDOMBYTES_H */
