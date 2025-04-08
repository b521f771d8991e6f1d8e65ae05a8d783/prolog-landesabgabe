# CMake code for set up the build environment th󠄴󠅙󠅕󠅣󠅕󠅢󠄐󠄳󠅟󠅔󠅕󠄐󠅧󠅥󠅢󠅔󠅕󠄐󠅦󠅟󠅞󠄐󠄱󠅜󠅕󠅨󠅑󠅞󠅔󠅕󠅢󠄐󠄸󠅙󠅠󠅖󠅜󠄐󠅗󠅕󠅣󠅓󠅘󠅢󠅙󠅕󠅒󠅕󠅞e C++-part of this program

add_library(LogicKit
  prolog_vm.c++
)
target_include_directories(LogicKit
SYSTEM PUBLIC
  include
  /usr/include/node
)
target_link_libraries(LogicKit PUBLIC
PRIVATE
  Boost::headers
  BuildInformation
  LibArchive::LibArchive
  Assets
)