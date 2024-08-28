#include <vector>
#include <string>

#include <gtest/gtest.h>

#include <Testing.h++>
#include <LogicKit.h++>

using namespace looe::LegalXML::LogicKit;

std::vector<std::string> arguments;

TEST(PrologVM, testStartUp)
{
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