#include <assert.h>
#include <stdlib.h>

#include <mutex>
#include <string>
#include <fstream>
#include <filesystem>
#include <functional>
#include <iostream>

#include <boost/filesystem.hpp>

// swi-prolog is included in header

#include <archive.h>
#include <archive_entry.h>

#include "assets.h"

#include "LogicKit.h++"

namespace looe::LogicKit
{

void
create_swipl_home_run_path(const std::filesystem::path &root)
{
  std::filesystem::create_directories(root / "Library");
  std::filesystem::create_directories(root / "Library" / "SWIPL");
  std::filesystem::create_directories(root / "Library" / "SWIPL" / "home");
}

const std::string swiplHomeRunPath("Library/SWIPL/home");

void
create_empty_root_dir(const std::filesystem::path &rootDir)
{
  if(std::filesystem::exists(rootDir))
    {
      std::clog << "'" << rootDir.c_str() << "' already exists, deleting it.";
      std::filesystem::remove(rootDir);
    }

  std::filesystem::create_directory(rootDir);
}

void
init_prolog_home()
{
  static std::once_flag flag;

  std::call_once(flag, []() -> void {
    std::clog << "Stored archive of size " << swi_prolog_home_tar_size;

    static const std::filesystem::path rootDir(
      std::filesystem::temp_directory_path()
      / boost::filesystem::unique_path("%%%%-%%%%-%%%%-%%%%").c_str());

    create_empty_root_dir(rootDir);
    extract_archive_to_directory(rootDir, swi_prolog_home_tar,
                                 swi_prolog_home_tar_size);
  });
};

}