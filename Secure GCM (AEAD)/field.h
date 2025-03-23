/*
 * field.h
 *
 * Created: 2018-07-29 오후 3:28:54
 *  Author: 서석충
 */ 


#ifndef FIELD_H_
#define FIELD_H_


typedef unsigned int U32;
typedef unsigned short U16;
typedef unsigned char U8;
typedef int S32;
typedef short S16;
typedef char S8;
typedef char RET;

#define FFBITS 128
#define BLOCKS ( (FFBITS + sizeof(U8)*8-1) / (sizeof(U8)*8) )
#define DBLBLOCKS ( (FFBITS*2 + sizeof(U8)*8-1) / (sizeof(U8)*8) )

void reduce(U8* a);

void ff_mul_lrcomb(U8* a, U8* b, U8* c);

void bf_add_64bit_asm(U8* ret, U8* opA, U8* opB);
void bf_add_128bit_asm(U8* ret, U8* opA, U8* opB);
void bf_add_128bit_with_accu_asm(U8* ret, U8* opA, U8* opB, U8* opC);
void bf_add_128bit_accu_asm(U8* ret, U8* opA);	// opA가 L, H, M을 모두 포함하는 배열

RET bf_rtl_comb_32bit(U8* ret, U8* opA, U8* opB);
RET bf_rtl_comb_32bit_ASM(U8* ret, U8* opA, U8* opB);
RET bf_rtl_comb_32bit_ASM_Ver2(U8* ret, U8* opA, U8* opB);

RET bf_rtl_comb_64bit(U8* ret, U8* opA, U8* opB);
RET bf_kara_rtl_comb_64bit_ASM(U8* ret, U8* opA, U8* opB);
RET bf_kara_rtl_comb_64bit_ASM_Ver2(U8* ret, U8* opA, U8* opB);
RET bf_rtl_comb_64bit_with_encoding_ASM(U8* ret, U8* opA, U8* opB);

RET bf_kara_rtl_comb_128bit_ASM_Ver2(U8* ret, U8* opA, U8* opB);
RET bf_Kara_rtl_comb_128bit_ASM_Ver2_C(U8* ret, U8* opA, U8* opB);

#endif /* FIELD_H_ */