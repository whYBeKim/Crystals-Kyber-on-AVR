#ifndef REDUCE_H
#define REDUCE_H

#include "params.h"
#include <stdint.h>

extern int16_t small_LUT_reduce_asm(int16_t a);
extern int16_t LUT_reduce_asm (int32_t a);
extern int16_t csubq_asm(int16_t x);

#endif
