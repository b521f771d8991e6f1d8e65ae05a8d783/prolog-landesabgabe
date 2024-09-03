cmake_minimum_required(VERSION 3.28)
project(LX VERSION 1.0 LANGUAGES Swift CXX C)

enable_testing()

include(Build/BuildInformation.cmake)

include(Dependencies/Dependencies.cmake)

# configuration for our targets

# ActKit
add_library(ActKit
  Sources/ActKit/LegalElements.swift
  Sources/ActKit/LegalElementsBuilders.swift
  Sources/ActKit/Code.swift
)

add_executable(ActKitTests
  Sources/ActKit/Testing/Tests.swift
)
target_link_libraries(ActKitTests PUBLIC
  ActKit
)
add_test(
  NAME ActKitTests
  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/ActKitTests
)

# LogicKit
add_library(LogicKit
  Sources/LogicKit/SWIPrologHome.c
  Sources/LogicKit/LogicKit.c++
  Sources/LogicKit/Norm.swift
  Sources/LogicKit/TemplateEngine.swift
  Sources/LogicKit/LegalStatement.swift
  Sources/LogicKit/StdStatements.swift
)
add_dependencies(LogicKit zlib swi-prolog swi-prolog-home)
target_include_directories(LogicKit
PUBLIC
  Sources/LogicKit/include
  ${SWIPL_INCLUDE_DIR}
PRIVATE
  Sources/LogicKit/include-project
  ${LIBARCHIVE_INCLUDE_DIR}
)
target_compile_definitions(LogicKit PRIVATE
  SWI_PROLOG_HOME_STORE="${SWI_PROLOG_HOME_STORE_PATH}"
)
target_link_libraries(LogicKit PUBLIC
  ActKit
  ${SWIPL_LIBRARY}
  ${ZLIB_LIBRARY}
  ${LIBARCHIVE_LIBRARY}
  Boost::filesystem
  Boost::numeric_conversion
  incbin
  BuildInformation
)

add_executable(LogicKitTests
  Sources/LogicKit/Testing/Testing.c++
  Sources/LogicKit/Testing/LogicKitTests.swift
  Sources/LogicKit/Testing/main.swift
)
target_include_directories(LogicKitTests PUBLIC Sources/LogicKit/Testing/include)
target_link_libraries(LogicKitTests PUBLIC
  LogicKit
  ActKit
  GTest::gtest
  BuildInformation
)
add_test(
  NAME LogicKitTests
  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/LogicKitTests
)

# LX executable
add_executable(LX
  Sources/LX/main.swift
)
target_link_libraries(LX PRIVATE
  LogicKit
  ActKit
  BuildInformation
)

# configuration for all targets
set(TARGETS
  ActKit
  ActKitTests
  LogicKit
  LogicKitTests
  LX
)

if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang"
    OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  set(SWIFT_TESTABLE
    $<$<COMPILE_LANGUAGE:Swift>:-enable-testing>
  )

  set(Wall "$<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-Wall>")
  set(Wextra "$<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-Wextra>")
  set(Wpedantic "$<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-Wpedantic>")
  set(Werror "$<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-Werror>")
else()
  message("This program should be compiled with clang or gcc")
endif()

find_program(CLANG_TIDY_EXE NAMES "clang-tidy")
set(CLANG_TIDY_COMMAND "${CLANG_TIDY_EXE}")
set(CLANG_TIDY_OPTIONS "-checks=-*,bugprone-*,objc-*,cert-*,clang-analyzer-*,darwin-*,hicpp-*,performance-*,portability-*")

set_target_properties(PROPERTIES
    OBJCXX_CLANG_TIDY "${CLANG_TIDY_EXE};${CLANG_TIDY_OPTIONS}"
    OBJC_CLANG_TIDY "${CLANG_TIDY_EXE};${CLANG_TIDY_OPTIONS}"
    CXX_CLANG_TIDY "${CLANG_TIDY_EXE};${CLANG_TIDY_OPTIONS}"
    C_CLANG_TIDY "${CLANG_TIDY_EXE};${CLANG_TIDY_OPTIONS}"
  )

foreach(TARGET ${TARGETS})
  target_compile_options(${TARGET} PRIVATE
    ${SWIFT_TESTABLE}
    ${Wall}
    ${Wextra}
    ${Werror}
    ${Wpedantic}
  )

  set_target_properties(${TARGET} PROPERTIES
    COMPILE_WARNING_AS_ERROR ON
    
    CMAKE_Swift_LANGUAGE_VERSION 4

    CMAKE_OBJCXX_STANDARD 20
    CMAKE_CXX_STANDARD 20
    CMAKE_OBJC_STANDARD 11
    CMAKE_C_STANDARD 11

    CMAKE_OBJCXX_STANDARD_REQUIRED ON
    CMAKE_CXX_STANDARD_REQUIRED ON
    CMAKE_OBJC_STANDARD_REQUIRED ON
    CMAKE_C_STANDARD_REQUIRED ON

    CMAKE_OBJCXX_EXTENSIONS OFF
    CMAKE_CXX_EXTENSIONS OFF
    CMAKE_OBJC_EXTENSIONS OFF
    CMAKE_C_EXTENSIONS OFF
  )
endforeach()