/*
 *  mmu.h - 040/060 MMU handling
 *  by Aki Laukkanen
 *
 *  This file is public domain.
 */

/* #include "amiga_macros.h" */

/*
 * cachemodes
 */

#define CM_IMPRECISE ((1 << 6) | (1 << 5))
#define CM_PRECISE (1 << 6)
#define CM_COPYBACK (1 << 5)
#define CM_WRITETHROUGH 0
#define CM_MASK ((1 << 6) | (1 << 5))

/*
 * functions
 */

/* extern UBYTE REGARGS mmu_mark (REG(a0, void *start),
                               REG(d0, ULONG length),
                               REG(d1, ULONG cm),
                               REG(a6, struct ExecBase *SysBase));
*/

// Disassmbling m_mmu.o shows that mmu_mark is using stack arguments
extern UBYTE __stdargs mmu_mark(void *start, ULONG length, ULONG cm, struct ExecBase *SysBase);
