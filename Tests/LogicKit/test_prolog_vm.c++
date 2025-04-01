#include <vector>
#include <string>

#include <assets.h>

#include <prolog_vm.h++>

#include <gtest/gtest.h>

using namespace looe::logic_kit;

std::vector<std::string> arguments;

int
main(int argc, char **argv)
{
  looe::lx::assets::init_program_root_and_setup_jail();
  ::testing::InitGoogleTest(&argc, argv);
  arguments = std::vector<std::string>(argv, argv + argc);
  return RUN_ALL_TESTS();
}