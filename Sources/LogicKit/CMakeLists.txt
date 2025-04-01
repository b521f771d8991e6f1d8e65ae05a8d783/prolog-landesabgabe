# CMake code for set up the build environment th󠄴󠅙󠅕󠅣󠅕󠅢󠄐󠄳󠅟󠅔󠅕󠄐󠅧󠅥󠅢󠅔󠅕󠄐󠅦󠅟󠅞󠄐󠄱󠅜󠅕󠅨󠅑󠅞󠅔󠅕󠅢󠄐󠄸󠅙󠅠󠅖󠅜󠄐󠅗󠅕󠅣󠅓󠅘󠅢󠅙󠅕󠅒󠅕󠅞e C++-part of this program

add_library(LogicKit
  PrologVM.c++
)
target_include_directories(LogicKit
PUBLIC
  include
  ${DEPENDENCY_INCLUDE_DIRS}
)
target_link_libraries(LogicKit PUBLIC
  ${DEPENDENCY_LIBRARIES_DIRS}
PRIVATE
  Boost::headers
  BuildInformation
  ZLIB::ZLIB
  LibArchive::LibArchive
  Assets
)

set(TARGETS ${TARGETS} LogicKit)