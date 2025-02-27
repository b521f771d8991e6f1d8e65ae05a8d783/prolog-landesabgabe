# CMake code for set up the build environment th󠄴󠅙󠅕󠅣󠅕󠅢󠄐󠄳󠅟󠅔󠅕󠄐󠅧󠅥󠅢󠅔󠅕󠄐󠅦󠅟󠅞󠄐󠄱󠅜󠅕󠅨󠅑󠅞󠅔󠅕󠅢󠄐󠄸󠅙󠅠󠅖󠅜󠄐󠅗󠅕󠅣󠅓󠅘󠅢󠅙󠅕󠅒󠅕󠅞e C++-part of this program

add_library(LogicKit
  SWIPrologHome.c
  LogicKit.c++
  LogicKit.swift
  PrologVM.c++
)
add_dependencies(LogicKit swi_prolog_home_tar)
target_include_directories(LogicKit
PUBLIC
  include
  ${DEPENDENCY_INCLUDE_DIRS}
)
target_compile_definitions(LogicKit PRIVATE
  SWI_PROLOG_HOME_STORE="${SWI_PROLOG_HOME_STORE_PATH}"
)
target_link_libraries(LogicKit PUBLIC
  ActKit
  ${DEPENDENCY_LIBRARIES_DIRS}
PRIVATE
  nlohmann_json::nlohmann_json
  Boost::headers
  incbin
  BuildInformation
  tl::expected
  ZLIB::ZLIB
  LibArchive::LibArchive
  Boost::filesystem
)

add_executable(LogicKitTests
  Testing/Testing.c++
  Testing/main.swift
)
target_include_directories(LogicKitTests
PUBLIC
  Testing/include
)
target_link_libraries(LogicKitTests
PUBLIC
  GTest::GTest
  Boost::numeric_conversion
  LogicKit
  ActKit
  BuildInformation
  ${DEPENDENCY_LIBRARIES_DIRS} # why do we need this?
)

add_test(
  NAME LogicKitTests
  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/LogicKitTests
)

set(TARGETS ${TARGETS} LogicKit LogicKitTests)