#ifndef SWI_PROLOG_HOME_H
#define SWI_PROLOG_HOME_H

#define INCBIN_PREFIX lx_rawdata_
// #pragma GCC diagnostic push
// #pragma GCC diagnostic ignored "-Wnewline-eof"
//  this is brain-damaged, TODO: fix it upstream
#include <incbin.h>
// #pragma GCC diagnostic pop

#ifdef __cplusplus
extern "C"
{
#endif

  INCBIN_EXTERN(void *, SwiPrologHome);

#ifdef __cplusplus
}
#endif

#endif
