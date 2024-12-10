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

TEST(PrologVM, testPrologQueryTrue)
{
  const PrologQuery prologQuery("true");
  const std::vector<PrologQuery::ArgType> result = runQuery(prologQuery);
}

TEST(PrologVM, testPrologQueryFalse)
{
  const PrologQuery prologQuery("false");
  const std::vector<PrologQuery::ArgType> result = runQuery(prologQuery);
  ASSERT_EQ(result.size(), 0);
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