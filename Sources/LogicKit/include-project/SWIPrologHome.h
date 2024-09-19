#ifndef SWI_PROLOG_HOME_H
#define SWI_PROLOG_HOME_H

#define INCBIN_PREFIX lx_rawdata_

#ifdef __clang__
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wnewline-eof"
//  this is brain-damaged, TODO: fix it upstream
#endif

#include <incbin.h>

#ifdef __clang__
#pragma GCC diagnostic pop
#endif

#ifdef __cplusplus
extern "C"
{
#endif

  INCBIN_EXTERN(char *, SwiPrologHome);

#ifdef __cplusplus
}
#endif

#endif
