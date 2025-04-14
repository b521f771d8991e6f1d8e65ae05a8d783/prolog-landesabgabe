#ifndef PROLOGVM_H
#define PROLOGVM_H

#include <wasmedge/wasmedge.h>

namespace looe::logic_kit
{

class logic_vm
{
private:
  WasmEdge_ConfigureContext *context;
  WasmEdge_VMContext *vm_cxt;

public:
  logic_vm(void);
  ~logic_vm(void);
};

}

#endif