cmake_minimum_required(VERSION 3.28)
project(LX LANGUAGES Swift OBJCXX CXX OBJC C)

include(CTest)
include(Build/BuildInformation/BuildInformation.cmake)
include(Dependencies/Dependencies.cmake)

# configuration for our targets

add_subdirectory(Sources/Assets)
add_subdirectory(Sources/LogicKit)

# configuration for all targets
set(TARGETS
  Assets
  LogicKit
)

set(TEST_TARGETS
  #LogicKitTests
)

# add target configuration
if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang"
    OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  set(SWIFT_TESTABLE
    $<$<COMPILE_LANGUAGE:Swift>:-enable-testing>
  )

  set(Wall "$<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-Wall>")
  set(Wextra "$<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-Wextra>")
  set(Wpedantic "$<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-Wpedantic>")
  set(Werror "$<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-Werror>")
  set(CStandard "$<$<COMPILE_LANGUAGE:C,OBJC>:--std=c23>") # somehow this does not work right now using plain cmake, TODO remove this nonsense
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

foreach(TARGET ${TARGETS} ${TEST_TARGETS})
  target_compile_options(${TARGET} PRIVATE
    ${SWIFT_TESTABLE}
    ${Wall}
    ${Wextra}
    ${Werror}
    ${Wpedantic}
    ${CStandard}
  )

  set_target_properties(${TARGET} PROPERTIES
    COMPILE_WARNING_AS_ERROR ON
    
    CMAKE_Swift_LANGUAGE_VERSION 6

    CMAKE_OBJCXX_STANDARD 20
    CMAKE_CXX_STANDARD 20
    CMAKE_OBJC_STANDARD 23
    CMAKE_C_STANDARD 23

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
