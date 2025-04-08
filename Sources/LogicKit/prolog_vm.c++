#include <v8-isolate.h>
#include <vector>
#include <iostream>

#include <node.h>
#include <v8.h>

#include <prolog_vm.h++>

namespace looe::logic_kit
{

logic_vm::logic_vm()
{
  node::MultiIsolatePlatform *platform = 0;
  std::vector<std::string> args = {};
  std::vector<std::string> exec_args = {};

  std::unique_ptr<node::CommonEnvironmentSetup> setup
    = node::CommonEnvironmentSetup::Create(platform, &this->errors, args,
                                           exec_args);
  std::clog << "Initializing logicVm" << std::endl;

  v8::Isolate *isolate = setup->isolate();
  node::Environment *env = setup->env();
  (void)env;

  {
    v8::Locker locker(isolate);
    v8::Isolate::Scope isolate_scope(isolate);
    v8::HandleScope handle_scope(isolate);
    v8::Context::Scope context_scope(setup->context());
  }
}

} // namespace looe::LogicKit

using namespace node;