#ifndef ASSETS_H
#define ASSETS_H

#include <stdbool.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C"
{
#endif

  extern const char swi_prolog_home_tar[];
  extern const char lx_ui_home_tar[];
  extern const char corpus_tar[];

  extern const size_t swi_prolog_home_tar_size;
  extern const size_t lx_ui_home_tar_size;
  extern const size_t corpus_tar_size;

#ifdef __cplusplus
}

#include <optional>
#include <vector>
#include <filesystem>

extern void extract_archive_to_directory(const std::filesystem::path &rootDir,
                                         const void *buffer,
                                         const size_t &size);

extern void init_program_root(const std::string &root);

extern std::optional<std::string>
fetch_from_corpus(const std::string &file_name);

extern std::optional<std::string>
fetch_from_web_app_data(const std::string &file_name);

extern std::vector<std::string> list_corpus(void);

#endif

#endif
