﻿/*
 * zetas.c
 *
 * Created: 2023-03-24 오전 10:37:03
 */ 
#include <stdint.h>

int16_t ntt_zetas[64] = {	
	0x0011, 0x0AC9, 0x0247, 0x0A59, 0x0665, 0x02D3, 0x08F0, 0x044C,
	0x0581, 0x0A66, 0x0CD1, 0x00E9, 0x02F4, 0x086C, 0x0BC7, 0x0BEA,
	0x06A7, 0x0673, 0x0AE5, 0x06FD, 0x0737, 0x03B8, 0x05B5, 0x0A7F,
	0x03AB, 0x0904, 0x0985, 0x0954, 0x02DD, 0x0921, 0x010C, 0x0281,
	0x0630, 0x08FA, 0x07F5, 0x0C94, 0x0177, 0x09F5, 0x082A, 0x066D,
	0x0427, 0x013F, 0x0AD5, 0x02F5, 0x0833, 0x0231, 0x09A2, 0x0A22,
	0x0AF4, 0x0444, 0x0193, 0x0402, 0x0477, 0x0866, 0x0AD7, 0x0376,
	0x06BA, 0x04BC, 0x0752, 0x0405, 0x083E, 0x0B77, 0x0375, 0x086A };