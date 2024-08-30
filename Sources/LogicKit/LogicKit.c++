#include <sys/syslog.h>
#include <sys/ptrace.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <syslog.h>

#include <string.h>
#include <assert.h>

#include <mutex>
#include <algorithm>
#include <iostream>
#include <unistd.h>
#include <vector>
#include <string>
#include <fstream>
#include <filesystem>
#include <functional>

#include <boost/numeric/conversion/cast.hpp>
#include <boost/filesystem.hpp>

#include <SWI-Prolog.h>
#include <SWI-cpp2.h>

#include <archive.h>
#include <archive_entry.h>

#include <SWIPrologHome.h>

#include "LogicKit.h++"

#ifdef __linux__
#include <linux/seccomp.h>
#include <linux/filter.h>
#endif

namespace looe::LegalXML::LogicKit
{

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
  static const std::filesystem::path rootDir(
    std::filesystem::temp_directory_path()
    / boost::filesystem::unique_path("%%%%-%%%%-%%%%-%%%%").c_str());

  if(std::filesystem::exists(rootDir))
    {
      syslog(LOG_DEBUG, "'%s' already exists, deleting it.", rootDir.c_str());
      std::filesystem::remove(rootDir);
    }

  std::filesystem::create_directory(rootDir);

#ifdef DUMP_EMBEDDED_TAR
  {
    const std::filesystem::path dumpTarPath("tar-dump.tar");
    if(std::filesystem::exists(dumpTarPath))
      {
        std::filesystem::remove(dumpTarPath);
      }
    std::ofstream s(dumpTarPath, std::ios::binary);
    s.write(reinterpret_cast<const char *>(lx_rawdataSwiPrologHomeData),
            lx_rawdataSwiPrologHomeSize);
    s.close();
  }
#endif

  struct archive *archive = archive_read_new();
  archive_read_support_format_tar(archive);
  archive_read_support_filter_xz(archive);
  archive_read_open_memory(archive, lx_rawdata_SwiPrologHomeData,
                           lx_rawdata_SwiPrologHomeSize);

  printf("Stored archive of size %i from ('%s')\n",
         lx_rawdata_SwiPrologHomeSize, SWI_PROLOG_HOME_STORE);

  if(archive == nullptr)
    {
      syslog(LOG_ERR, "Failed to open in-memory archive");
      return;
    }

  struct archive_entry *entry(nullptr);
  int r(0);

  if(chdir(rootDir.c_str()) == -1)
    {
      syslog(LOG_ERR, "Could not change dir: %s", strerror(errno));
    }

#ifdef SECURITY_JAIL
  if(getuid() == 0)
    {
      if(chroot(".") == -1)
        {
          syslog(LOG_ERR, "Could not chroot to .: %s", strerror(errno));
        }
      else
        {
          std::cout << "Successfully set up chroot." << std::endl;
        }
    }

#ifdef __linux__
  if(syscall(SYS_seccomp, SECCOMP_SET_MODE_STRICT, 0, NULL) != 0)
    {
      syslog(LOG_ERR, "Could not execute secomp syscall ('%s')",
             strerror(errno));
    }
  else
    {
      syslog(LOG_INFO, "Successfully set up seccomp (hic sunt dracones 🐉).").
    }
#endif

#endif

  while((r = archive_read_next_header(archive, &entry)) == ARCHIVE_OK)
    {
      std::string currentFile(archive_entry_pathname(entry));
      syslog(LOG_DEBUG, "Extracting: %s", currentFile.c_str());

      if(archive_entry_filetype(entry) == AE_IFDIR)
        {
          if(mkdir(currentFile.c_str(), 0755) != 0)
            {
              std::cerr << "Failed to create directory: " << currentFile
                        << std::endl;
            }
          continue;
        }
      else
        {
          std::ofstream outFile(currentFile, std::ios::out);
          if(!outFile)
            {
              std::cerr << "Failed to create file: " << currentFile
                        << std::endl;
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

// TODO: replace this by the embedded swipl-home-dir
PrologVM::PrologVM(const std::string &argv0)
    : args({ argv0, "--home=/usr/lib64/swipl-9.2.6" }),
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
      syslog(LOG_DEBUG, "shutting down SWI Prolog");
      PL_halt(0);
    }
}
}