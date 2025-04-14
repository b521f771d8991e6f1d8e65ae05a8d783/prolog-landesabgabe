#include <stdexcept>
#include <iostream>

#include <wasmedge/wasmedge.h>

#include <prolog_vm.h++>

namespace looe::logic_kit
{

logic_vm::logic_vm(void)
{
  this->context = WasmEdge_ConfigureCreate();
  this->vm_cxt = WasmEdge_VMCreate(this->context, nullptr);
  if(this->vm_cxt == nullptr)
    {
      throw std::runtime_error("Could not initialise wasmedge");
    }
  std::clog << "Initialised new LogicVM" << std::endl;
}

logic_vm::~logic_vm()
{
  WasmEdge_VMDelete(this->vm_cxt);
  WasmEdge_ConfigureDelete(this->context);
}

} // namespace looe::LogicKit