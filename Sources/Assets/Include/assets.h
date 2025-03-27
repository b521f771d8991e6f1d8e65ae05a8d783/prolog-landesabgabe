#ifndef ASSETS_H
#define ASSETS_H

#include <stdbool.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C"
{
#endif

  extern const char assets_tar[];

  extern const size_t assets_tar_size;

#ifdef __cplusplus
}

#include <optional>
#include <vector>
#include <filesystem>

extern void extract_archive_to_directory(const std::filesystem::path &rootDir,
                                         const void *buffer,
                                         const size_t &size);

extern std::filesystem::path init_program_root(const std::filesystem::path &root
                                               = std::tmpnam(nullptr));

extern std::vector<std::filesystem::path> list_all();
extern std::vector<std::filesystem::path> list(const std::string & = "");
extern std::optional<std::string> fetch(const std::filesystem::path &);
extern std::optional<std::string> fetch(const std::filesystem::path &prefix,
                                        const std::filesystem::path &file_name);

#endif

#endif
