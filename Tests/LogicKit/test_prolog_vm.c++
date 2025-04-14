#include <assets.h>

#include <prolog_vm.h++>

#include <gtest/gtest.h>

using namespace looe::logic_kit;

TEST(test_logic_vm, test_startup)
{
  logic_vm lvm;
  std::cout << "Prolog VM has size of" << sizeof(lvm) << std::endl;
}