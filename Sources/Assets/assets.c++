#include <iostream>
#include <fstream>
#include <filesystem>

#include <archive.h>
#include <archive_entry.h>

#include <boost/filesystem.hpp>

#include "assets.h"

void
extract_archive_to_directory(const std::filesystem::path &rootDir,
                             const void *buffer, const size_t &size)
{
  struct archive *archive = archive_read_new();

  archive_read_support_format_tar(archive);

  archive_read_open_memory(archive, buffer, size);

  struct archive_entry *entry(nullptr);
  int entryNumber(0);

  while((entryNumber = archive_read_next_header(archive, &entry)) == ARCHIVE_OK)
    {
      const std::string entryPath(
        std::string(archive_entry_pathname(entry)).substr(2));
      const std::filesystem::path currentFile(rootDir / entryPath);

      std::clog << "Extracting to '" << currentFile << "'" << std::endl;

      if(archive_entry_filetype(entry) == AE_IFDIR)
        {
          if(!std::filesystem::create_directory(currentFile.c_str()))
            {
              std::cerr << "Failed to create directory: " << currentFile.c_str()
                        << std::endl;
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
}

extern void
init_program_root(const std::string &root)
{
  std::filesystem::path root_dir(root);
  extract_archive_to_directory(root_dir / "corpus", corpus_tar,
                               corpus_tar_size);
  extract_archive_to_directory(root_dir / "lxui", lx_ui_home_tar,
                               lx_ui_home_tar_size);
  extract_archive_to_directory(root_dir / "swipl", swi_prolog_home_tar,
                               swi_prolog_home_tar_size);
}

std::optional<std::string>
fetch_from_corpus(const std::string &file_name)
{
  (void)file_name;
  return std::nullopt;
}

std::optional<std::string>
fetch_from_web_app_data(const std::string &file_name)
{
  (void)file_name;
  return std::nullopt;
}

std::vector<std::string>
list_corpus(void)
{
  return {};
}