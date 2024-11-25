add_library(LogicKit
  SWIPrologHome.c
  LogicKit.c++
  LogicKit.swift
)
add_dependencies(LogicKit swi-prolog-home)
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
  ZLIB::ZLIB
  LibArchive::LibArchive
  Boost::filesystem
  Boost::headers
  incbin
  BuildInformation
)

add_executable(LogicKitTests
  Testing/Testing.c++
  Testing/main.swift
)
target_include_directories(LogicKitTests
PUBLIC
  Testing/include
)
target_link_libraries(LogicKitTests PUBLIC
  GTest::GTest
  Boost::numeric_conversion
  LogicKit
  ActKit
  BuildInformation
  ${CURSES_LIBRARIES} # why do we need this?
)
add_test(
  NAME LogicKitTests
  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/LogicKitTests
)

set(TARGETS ${TARGETS} LogicKit LogicKitTests)