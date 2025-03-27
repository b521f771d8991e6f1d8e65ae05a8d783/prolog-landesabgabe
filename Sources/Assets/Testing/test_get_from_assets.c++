#include <assert.h>

#include <string>
#include <iostream>

#include <gtest/gtest.h>

#include <assets.h>

TEST(asset_test, test_open_file)
{
  init_program_root();

  // try to open every file
  for(const std::string &file : list())
    {
      auto i = fetch(file);
      ASSERT_TRUE(i.has_value());
    }
}