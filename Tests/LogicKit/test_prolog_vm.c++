#include <complex>
#include <vector>
#include <string>

#include <assets.h>

#include <PrologVM.h++>

#include <gtest/gtest.h>

using namespace looe::LogicKit;

std::vector<std::string> arguments;

TEST(PrologVM, testStartUp)
{
  start_prolog_VM(arguments[0], "swipl");
  ASSERT_TRUE(is_initialised());
}

TEST(PrologVM, testPrologQueryTrue)
{
  const prolog_query true_query("true");
  ASSERT_EQ(0, true_query.get_arity());
  ASSERT_EQ("true", true_query.get_predicate_name());
  const prolog_result result = run_query(true_query);
}

TEST(PrologVM, testPrologQueryFalse)
{
  // const prolog_query prologQuery("false");
  // const std::vector<prolog_query::arg_type> result = run_query(prologQuery);
  // ASSERT_EQ(result.size(), 0);
}

int
main(int argc, char **argv)
{
  looe::lx::assets::init_program_root_and_setup_jail();
  ::testing::InitGoogleTest(&argc, argv);
  arguments = std::vector<std::string>(argv, argv + argc);
  return RUN_ALL_TESTS();
}