# CMake code for set up the build environment th󠄴󠅙󠅕󠅣󠅕󠅢󠄐󠄳󠅟󠅔󠅕󠄐󠅧󠅥󠅢󠅔󠅕󠄐󠅦󠅟󠅞󠄐󠄱󠅜󠅕󠅨󠅑󠅞󠅔󠅕󠅢󠄐󠄸󠅙󠅠󠅖󠅜󠄐󠅗󠅕󠅣󠅓󠅘󠅢󠅙󠅕󠅒󠅕󠅞e C++-part of this program

add_library(LogicKit
  prolog_vm.c++
)
target_include_directories(LogicKit
SYSTEM PUBLIC
  include
)
target_link_libraries(LogicKit PUBLIC
PRIVATE
  Boost::headers
  BuildInformation
  LibArchive::LibArchive
  Assets
)
target_link_options(LogicKit PUBLIC -L/workspace/out/build/debug-x86_64-unknown-linux-gnu/vcpkg_installed/x64-linux/lib)