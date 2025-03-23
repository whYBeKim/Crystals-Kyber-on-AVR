/*
 * wpa_supplicant/hostapd - Default include files
 * Copyright (c) 2005-2006, Jouni Malinen <j@w1.fi>
 *
 * This software may be distributed under the terms of the BSD license.
 * See README for more details.
 *
 * This header file is included into all C files so that commonly used header
 * files can be selected with OS specific ifdef blocks in one place instead of
 * having to have OS/C library specific selection in many files.
 */

#ifndef INCLUDES_H
#define INCLUDES_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* Define platform specific integer types */

#include <stdint.h>

typedef uint32_t u32;
typedef uint16_t u16;
typedef uint8_t u8;
typedef int32_t s32;
typedef int16_t s16;
typedef int8_t s8;

/* Macros for handling unaligned memory accesses */

static inline u32 WPA_GET_BE32(const u8 *a)
{
  return ((u32)a[0] << 24) | ((u32)a[1] << 16) | ((u32)a[2] << 8) | a[3];
}

static inline void WPA_PUT_BE32(u8 *a, u32 val)
{
  a[0] = (val >> 24) & 0xff;
  a[1] = (val >> 16) & 0xff;
  a[2] = (val >> 8) & 0xff;
  a[3] = val & 0xff;
}

#endif /* INCLUDES_H */
