#include <assert.h>
#include <stdlib.h>

#include <mutex>
#include <algorithm>
#include <string>
#include <fstream>
#include <filesystem>
#include <functional>
#include <iostream>

#include <boost/numeric/conversion/cast.hpp>
#include <boost/filesystem.hpp>

// swi-prolog is included in header

#include <archive.h>
#include <archive_entry.h>

#include <SWIPrologHome.h>

#include "LogicKit.h++"

namespace looe::LegalXML::LogicKit
{

void
createSwiplHomeRunPath(const std::filesystem::path &root)
{
  std::filesystem::create_directories(root / "Library");
  std::filesystem::create_directories(root / "Library" / "SWIPL");
  std::filesystem::create_directories(root / "Library" / "SWIPL" / "home");
}

const std::string swiplHomeRunPath("Library/SWIPL/home");

class LaunchOnStartup final
{
private:
  std::function<void(void)> executeOnExit;

public:
  LaunchOnStartup(
    const std::function<void(void)> &fun,
    const std::function<void(void)> &onExit = [] {})
      : executeOnExit(onExit)
  {
    try
      {
        fun();
      }
    catch(...)
      {
      }
  }

  ~LaunchOnStartup(void) { this->executeOnExit(); }
};

LaunchOnStartup i([]() -> void {
  static std::once_flag flag;
  std::call_once(flag, []() -> void {
    ::std::clog << "Stored archive of size " << lx_rawdata_SwiPrologHomeSize
                << " from (" << SWI_PROLOG_HOME_STORE << ")\n";

    static const std::filesystem::path rootDir(
      std::filesystem::temp_directory_path()
      / boost::filesystem::unique_path("%%%%-%%%%-%%%%-%%%%").c_str());

    if(std::filesystem::exists(rootDir))
      {
        std::clog << "'" << rootDir.c_str() << "' already exists, deleting it.";
        std::filesystem::remove(rootDir);
      }

    std::filesystem::create_directory(rootDir);

#ifdef DEBUG
    {
      const std::filesystem::path dumpTarPath(
        std::filesystem::temp_directory_path() / "tar-dump.tar");
      if(std::filesystem::exists(dumpTarPath))
        {
          std::filesystem::remove(dumpTarPath);
        }
      std::ofstream s(dumpTarPath, std::ios::binary);
      s.write(lx_rawdata_SwiPrologHomeData, lx_rawdata_SwiPrologHomeSize);
      s.close();
      printf("Dumped tar to: %s\n", dumpTarPath.c_str());
    }
#endif

    struct archive *archive = archive_read_new();

    archive_read_support_format_tar(archive);

    archive_read_open_memory(archive, lx_rawdata_SwiPrologHomeData,
                             lx_rawdata_SwiPrologHomeSize);

    struct archive_entry *entry(nullptr);
    int entryNumber(0);

    std::filesystem::current_path(rootDir.c_str());
    createSwiplHomeRunPath(rootDir);

    while((entryNumber = archive_read_next_header(archive, &entry))
          == ARCHIVE_OK)
      {
        const std::string entryPath(
          std::string(archive_entry_pathname(entry)).substr(2));
        const std::filesystem::path currentFile(rootDir / swiplHomeRunPath
                                                / entryPath);

        std::clog << "Extracting to '" << currentFile << "'" << std::endl;

        if(archive_entry_filetype(entry) == AE_IFDIR)
          {
            if(!std::filesystem::create_directory(currentFile.c_str()))
              {
                std::cerr << "Failed to create directory: "
                          << currentFile.c_str() << std::endl;
              }
            continue;
          }
        else
          {
            std::ofstream outFile(currentFile, std::ios::out);

            if(!outFile)
              {
                std::cerr << "Failed to create file: " << currentFile.c_str();
                continue;
              }

            std::array<char, 4096> buffer;
            ssize_t bytesRead(0);

            while((bytesRead
                   = archive_read_data(archive, buffer.data(), buffer.size()))
                  > 0)
              {
                outFile.write(buffer.data(), bytesRead);
              }

            outFile.close();
          }
      }

    archive_read_close(archive);
    archive_read_free(archive);
  });
});

template <typename T, typename A>
std::vector<T>
map(std::vector<A> &container, T (*const f)(A &))
{
  std::vector<T> output;
  output.reserve(container.size());
  std::transform(container.begin(), container.end(), std::back_inserter(output),
                 f);
  return output;
}

PrologVM::PrologVM(const std::string &argv0)
    : args(std::vector<std::string>{ argv0, std::string("--home=")
                                              + swiplHomeRunPath }),
      cArgs(map(
        this->args, +[](std::string &i) -> char * { return &i[0]; })),
      engine(boost::numeric_cast<int>(this->cArgs.size()), this->cArgs.data())
{
  assert(PL_is_initialised(nullptr, nullptr));
}

bool
PrologVM::isInitialised(void)
{
  return PL_is_initialised(nullptr, nullptr);
}

PrologVM::~PrologVM(void)
{
  if(PL_is_initialised(nullptr, nullptr))
    {
      std::cerr << "shutting down SWI Prolog" << std::endl;
      PL_halt(0);
    }
}
}