#include <vector>
#include <string>
#include <iostream>

#include <gtest/gtest.h>

#include <Testing.h++>
#include <LogicKit.h++>
#include <PrologVM.h++>

#include <BuildInformation.h>

using namespace looe::LogicKitC;

std::vector<std::string> arguments;

TEST(PrologVM, testStartUp)
{
  std::cout
    << "Running Tests in version: "
    << BuildInformation::VersionString::getCurrentVersion().toString()
    << std::endl;
  startPrologVM(arguments[0]);
  ASSERT_TRUE(isInitialised());
}

TEST(PrologVM, testPrologQuery)
{
  const std::string prologPredicate = "true";
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