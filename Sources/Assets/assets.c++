#include <algorithm>
#include <iterator>
#include <string>
#include <unistd.h>

#include <iostream>
#include <fstream>
#include <filesystem>
#include <array>
#include <optional>
#include <ranges>

#include <archive.h>
#include <archive_entry.h>
#include <vector>

#include "assets.h"

namespace looe::lx::assets
{

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

// TODO improve this and remove the need for the Sources/Assets by some native
// swift functionality
extern "C" char
  _binary__workspace_out_build_debug_x86_64_unknown_linux_gnu_Sources_Assets_assets_tar_start
    [];
extern "C" char
  _binary__workspace_out_build_debug_x86_64_unknown_linux_gnu_Sources_Assets_assets_tar_end
    [];
const size_t asset_tar_size
  = _binary__workspace_out_build_debug_x86_64_unknown_linux_gnu_Sources_Assets_assets_tar_end
    - _binary__workspace_out_build_debug_x86_64_unknown_linux_gnu_Sources_Assets_assets_tar_start;

extern std::filesystem::path
init_program_root(const std::filesystem::path &root)
{
  std::filesystem::path root_dir(root);
  std::cout << "Size is " << asset_tar_size << std::endl;

  extract_archive_to_directory(
    root_dir,
    _binary__workspace_out_build_debug_x86_64_unknown_linux_gnu_Sources_Assets_assets_tar_start,
    asset_tar_size);
  program_root = root;
  return root;
}

std::vector<std::filesystem::path>
list_all()
{
  if(!program_root.has_value())
    {
      std::clog << "Current program root has no value" << std::endl;
      return {};
    }

  std::vector<std::filesystem::path> file_list;
  std::clog << "Querying all files from " << program_root.value() << std::endl;

  for(const auto &entry :
      std::filesystem::recursive_directory_iterator(program_root.value()))
    {
      if(entry.is_regular_file())
        {
          std::string file_path = entry.path().string();
          file_list.push_back(file_path);
        }
    }

  return file_list;
}

bool
is_subdirectory(const std::filesystem::path &subdir,
                const std::filesystem::path &dir)
{
  // Get the canonical paths to handle symbolic links and relative paths
  std::filesystem::path canonicalX = std::filesystem::canonical(subdir);
  std::filesystem::path canonicalY = std::filesystem::canonical(dir);

  // Check if canonicalX starts with canonicalY
  return canonicalX.string().find(canonicalY.string()) == 0
         && canonicalX.string().size() > canonicalY.string().size();
}

std::vector<std::filesystem::path>
list(const std::string &prefix)
{
  if(!program_root.has_value())
    {
      std::clog << "Current program root has no value" << std::endl;
      return {};
    }

  const std::filesystem::path prefix_within_root
    = program_root.value() / prefix;

  if(!std::filesystem::exists(prefix_within_root))
    {
      std::cerr << "Prefix '" << prefix << "' does not exist within root '"
                << program_root.value() << "'";
      return {};
    }

  std::vector<std::filesystem::path> all(list_all());
  std::vector<std::filesystem::path> ret;
  ret.reserve(all.size());

  for(const std::filesystem::path &i : all)
    {
      if(prefix == "" or is_subdirectory(i, prefix_within_root))
        {
          ret.push_back(i);
        }
    }

  return ret;
}

std::optional<std::filesystem::path>
fetch(const std::filesystem::path &file_name)
{
  if(!program_root.has_value())
    {
      std::clog << "Current program root has no value" << std::endl;
      return {};
    }

  const std::filesystem::path path = program_root.value() / file_name;

  if(!std::filesystem::exists(path))
    {
      std::cerr << "The requested file does not exist" << std::endl;
      return std::nullopt;
    }

  if(!is_subdirectory(path, program_root.value()))
    {
      std::cerr << "The requested file is not inside the asset folder"
                << std::endl;
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

std::optional<std::filesystem::path>
fetch(const std::filesystem::path &prefix,
      const std::filesystem::path &file_name)
{
  return fetch(prefix / file_name);
}

std::string
path_to_relative_string(const std::filesystem::path &path)
{
  return std::filesystem::relative(path, program_root.value()).c_str();
}

std::string
fetch_string(const std::string &prefix, const std::string &file_name)
{
  const std::optional<std::filesystem::path> ret = fetch(prefix, file_name);
  if(ret.has_value())
    {
      return ret.value();
    }
  else
    {
      return "";
    }
}

std::vector<std::string>
list_strings(const std::string &prefix)
{
  std::vector<std::filesystem::path> got = list(prefix);
  std::vector<std::string> ret;
  ret.reserve(got.size());

  std::transform(got.begin(), got.end(), std::back_inserter(ret),
                 path_to_relative_string);

  return ret;
}

void
move_to_program_root(void)
{
  if(program_root.has_value())
    {
      chdir(program_root.value().c_str());
    }
}

bool
init_program_root_and_setup_jail(void)
{
  init_program_root();
  move_to_program_root();

  // if(getuid() == 0)
  //   {
  //     if(int err = chroot("."))
  //       {
  //         std::clog << "Tried to chroot, returned" << err << std::endl;
  //       }
  //   }

  return true;
}

}