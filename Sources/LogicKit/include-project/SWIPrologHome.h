#ifndef SWI_PROLOG_HOME_H
#define SWI_PROLOG_HOME_H

#define INCBIN_PREFIX lx_rawdata_
#include <incbin.h>

#ifdef __cplusplus
extern "C"
{
#endif

  INCBIN_EXTERN(void *, SwiPrologHome);

#ifdef __cplusplus
}
#endif

#endif
