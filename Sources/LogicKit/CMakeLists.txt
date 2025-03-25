# CMake code for set up the build environment th󠄴󠅙󠅕󠅣󠅕󠅢󠄐󠄳󠅟󠅔󠅕󠄐󠅧󠅥󠅢󠅔󠅕󠄐󠅦󠅟󠅞󠄐󠄱󠅜󠅕󠅨󠅑󠅞󠅔󠅕󠅢󠄐󠄸󠅙󠅠󠅖󠅜󠄐󠅗󠅕󠅣󠅓󠅘󠅢󠅙󠅕󠅒󠅕󠅞e C++-part of this program

add_library(LogicKit
  LogicKit.c++
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
  Boost::filesystem
  Assets
)

#add_executable(LogicKitTests
#  Testing/Testing.c++
#)
#target_include_directories(LogicKitTests
#PUBLIC
#  Testing/include
#)
#target_link_libraries(LogicKitTests
#PUBLIC
#  GTest::GTest
#  Boost::numeric_conversion
#  LogicKit
#  BuildInformation
#  ${DEPENDENCY_LIBRARIES_DIRS} # why do we need this?
#)
#
#add_test(
#  NAME LogicKitTests
#  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/LogicKitTests
#)

set(TARGETS ${TARGETS} LogicKit)