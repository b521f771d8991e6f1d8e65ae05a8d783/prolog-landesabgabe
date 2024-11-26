#include <vector>
#include <string>
#include <iostream>

#include <gtest/gtest.h>

#include <Testing.h++>
#include <LogicKit.h++>
#include <PrologVM.h++>

#include <BuildInformation.h>

using namespace looe::LogicKit;

std::vector<std::string> arguments;

TEST(PrologVM, testStartUp)
{
  std::cout
    << "Running Tests in version: "
    << BuildInformation::VersionString::getCurrentVersion().toString()
    << std::endl;
  PrologVM pvm(arguments[0]);
  ASSERT_TRUE(pvm.isInitialised());
}

namespace looe::LX::TestingC
{

int
executeTests(std::string argv0)
{
  arguments = { std::move(argv0) };
  testing::InitGoogleTest();
  return RUN_ALL_TESTS();
}

}