/*
Copyright (C) 1994-1995 Apogee Software, Ltd.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/
#ifndef _watcom_h_public
#define _watcom_h_public

#ifdef C_FIXED_MATH
fixed FixedMul(fixed a, fixed b);
fixed FixedDiv2(fixed a, fixed b);

static inline fixed FixedMul(fixed a, fixed b)
{
    __int64 scratch1 = (__int64)a * (__int64)b + (__int64)0x8000;
    return (scratch1 >> 16) & 0xffffffff;
}

static inline fixed FixedDiv2(fixed a, fixed b)
{
    __int64 x = (signed int)a;
    __int64 y = (signed int)b;
    __int64 z = x * 65536 / y;
    return (z)&0xffffffff;
}

#else
fixed (*FixedMul)(fixed a, fixed b);
fixed (*FixedDiv2)(fixed a, fixed b);
fixed FixedMul040(fixed eins, fixed zwei);
fixed FixedDiv040(fixed eins, fixed zwei);
fixed FixedMul060(fixed eins, fixed zwei);
fixed FixedDiv060(fixed eins, fixed zwei);
#endif

#ifndef __mc68060__
// FIXME: not 060 friendly
inline static fixed FixedScale(fixed orig, fixed factor, fixed divisor)
{
    __asm __volatile(
        "muls.l %1,%1:%0 \n\t"
        "divs.l %4:%1,%0 \n\t"
        : "=d"(orig), "=d"(factor)
        : "0"(orig), "1"(factor), "d"(divisor)
        );
    return orig;
}

// FIXME: not 060 friendly
inline static fixed FixedMulShift(fixed eins, fixed zwei, int shift)
{
    __asm __volatile(
        "muls.l %1,%1:%0 \n\t"
        : "=d"(eins), "=d"(zwei)
        : "0"(eins), "1"(zwei)
        );
    return ((unsigned int)eins >> shift) | ((unsigned int)zwei << (32- shift)) ;
}
#else
fixed FixedScale(fixed orig, fixed factor, fixed divisor);
fixed FixedMulShift(fixed eins, fixed zwei, int shift);
#endif

#ifdef __WATCOMC__
#pragma aux FixedMul = "imul ebx", \
            "add  eax, 8000h"      \
            "adc  edx,0h"          \
            "shrd eax,edx,16" parm[eax][ebx] value[eax] modify exact[eax edx]

#pragma aux FixedMulShift = "imul ebx", "shrd eax,edx,cl" parm[eax][ebx][ecx] value[eax] modify exact[eax edx]

#pragma aux FixedDiv2 = "cdq", "shld edx,eax,16", "sal eax,16", \
            "idiv ebx" parm[eax][ebx] value[eax] modify exact[eax edx]
#pragma aux FixedScale = "imul ebx", "idiv ecx" parm[eax][ebx][ecx] value[eax] modify exact[eax edx]
#endif

#endif
