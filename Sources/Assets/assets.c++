#include <iostream>
#include <fstream>
#include <filesystem>

#include <archive.h>
#include <archive_entry.h>

#include <boost/filesystem.hpp>
#include <optional>

#include "assets.h"

void
extract_archive_to_directory(const std::filesystem::path &rootDir,
                             const void *buffer, const size_t &size)
{
  if(!std::filesystem::exists(rootDir))
    {
      std::filesystem::create_directories(rootDir);
    }

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

static std::optional<std::filesystem::path> program_root = std::nullopt;

extern std::string
init_program_root(const std::string &root)
{
  std::filesystem::path root_dir(root);
  extract_archive_to_directory(root_dir, assets_tar, assets_tar_size);
  program_root = root;
  return root;
}

std::vector<std::string>
list_all(const std::string_view &prefix)
{
  if(!program_root.has_value())
    {
      std::clog << "Current program root has no value" << std::endl;
      return {};
    }

  std::vector<std::string> file_list;
  std::clog << "Querying all files from " << program_root.value() << std::endl;

  for(const auto &entry :
      std::filesystem::recursive_directory_iterator(program_root.value()))
    {
      if(entry.is_regular_file())
        {
          std::string file_path = entry.path().string();
          if(prefix == "" or file_path.find(prefix) == 0)
            {
              file_list.push_back(file_path);
            }
        }
    }

  return file_list;
}

std::optional<std::string>
fetch(const std::string &file_name)
{
  if(!program_root.has_value())
    {
      std::clog << "Current program root has no value" << std::endl;
      return {};
    }

  const std::filesystem::path path = program_root.value() / file_name;

  if(!std::filesystem::exists(path))
    {
      return std::nullopt;
    }

  std::ifstream file(path);
  if(!file.is_open())
    {
      std::clog << "Failed to open file: " << path << std::endl;
      return std::nullopt;
    }

  std::stringstream buffer;
  buffer << file.rdbuf();
  return buffer.str();
}