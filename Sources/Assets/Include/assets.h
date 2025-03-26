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

extern std::string init_program_root(const std::string &root
                                     = std::tmpnam(nullptr));

extern std::vector<std::string> list_all(const std::string_view &prefix = "");
extern std::optional<std::string> fetch(const std::string &);

#endif

#endif
