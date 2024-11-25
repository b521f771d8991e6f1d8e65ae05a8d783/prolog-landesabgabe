cmake_minimum_required(VERSION 3.28)
project(LX LANGUAGES Swift OBJCXX CXX OBJC C)

include(CTest)
include(Build/BuildInformation.cmake)
include(Dependencies/Dependencies.cmake)

# configuration for our targets

add_subdirectory(Sources/ActKit)
add_subdirectory(Sources/LogicKit)
add_subdirectory(Sources/Corpus)

# configuration for all targets
set(TARGETS
  ActKit
  ActKitTests
  LogicKit
  LogicKitTests
)

# Swift-Targets
find_program(SWIFT NAMES "swift")
find_program(CLANG NAMES "clang")
find_program(CLANGXX NAMES "clang++")

add_custom_target(SwiftPackage
  COMMAND
    "CC=${CLANG}" "CXX=${CLANGXX}"
    ${SWIFT} "build"
    --configuration debug
    --package-path ${CMAKE_CURRENT_SOURCE_DIR}
    #-I${CMAKE_CURRENT_BINARY_DIR}/Sources/ActKit
    #-I${CMAKE_CURRENT_BINARY_DIR}/Sources/LogicKit
    #-L${CMAKE_CURRENT_BINARY_DIR}/Sources/ActKit
    #-L${CMAKE_CURRENT_BINARY_DIR}/Sources/LogicKit
)
add_dependencies(SwiftPackage ${TARGETS})

# additional configuration
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
    CMAKE_OBJC_STANDARD 17
    CMAKE_C_STANDARD 17

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