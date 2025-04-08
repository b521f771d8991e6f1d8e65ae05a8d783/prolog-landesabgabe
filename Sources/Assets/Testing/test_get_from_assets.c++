#include <assert.h>

#include <string>
#include <iostream>

#include <gtest/gtest.h>

#include <assets.h>

using namespace looe::lx::assets;

class asset_tests : public testing::Test
{
protected:
  virtual void
  SetUp()
  {
    init_program_root();
  }
};

TEST_F(asset_tests, test_open_file)
{
  // try to open every file
  for(const std::string &file : list())
    {
      auto i = fetch(file);
      ASSERT_TRUE(i.has_value());
    }
}

TEST_F(asset_tests, test_list)
{
  for(const std::string &i : looe::lx::assets::list_strings("Corpus"))
    {
      ASSERT_NE(i.rfind("/tmp", 0), 0);
    }

  for(const std::string &i : looe::lx::assets::list_strings())
    {
      ASSERT_TRUE(i.rfind("swipl/", 0) == 0 or i.rfind("Corpus/", 0) == 0
                  or i.rfind("dist/", 0) == 0);
    }
}