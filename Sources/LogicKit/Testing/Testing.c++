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
  std::cout << "Running Tests in version: "
            << BuildInformation::VersionString::getCurrentVersion().toString()
            << std::endl;
  start_prolog_VM(arguments[0]);
  ASSERT_TRUE(is_initialised());
}

TEST(PrologVM, testPrologQueryTrue)
{
  // const prolog_query prologQuery("true");
  // const std::vector<prolog_query::arg_type> result = run_query(prologQuery);
}

TEST(PrologVM, testPrologQueryFalse)
{
  // const prolog_query prologQuery("false");
  // const std::vector<prolog_query::arg_type> result = run_query(prologQuery);
  // ASSERT_EQ(result.size(), 0);
}

namespace looe::LX::TestingC
{

int
execute_tests(std::string argv0)
{
  arguments = { std::move(argv0) };
  testing::InitGoogleTest();
  return RUN_ALL_TESTS();
}

}