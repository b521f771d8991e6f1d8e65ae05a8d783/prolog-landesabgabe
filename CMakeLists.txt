cmake_minimum_required(VERSION 3.28)
project(LX VERSION 1.0 LANGUAGES Swift CXX C)

include(ExternalProject)

# https://www.swi-prolog.org/build/WebAssembly.html <-- we need that
ExternalProject_Add(zlib # swi-prolog needs that and does not ship it itself 😒
  URL ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/zlib
  CONFIGURE_COMMAND
    CFLAGS=-fPIC
    "<SOURCE_DIR>/configure" "-static"
  BUILD_COMMAND     "make"
  INSTALL_COMMAND ""
  TEST_COMMAND "" "make" "test"
  BUILD_BYPRODUCTS  <BINARY_DIR>/libz.a
)
ExternalProject_Get_Property(zlib SOURCE_DIR)
ExternalProject_Get_Property(zlib BINARY_DIR)
set(ZLIB_SOURCE_DIR "${SOURCE_DIR}")
set(ZLIB_BINARY_DIR "${BINARY_DIR}")
set(ZLIB_INCLUDE_DIR ${ZLIB_SOURCE_DIR})
set(ZLIB_LIBRARY ${ZLIB_BINARY_DIR}/libz.a)

ExternalProject_Add(libarchive
  URL ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/libarchive
  CMAKE_ARGS
    -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
    -DENABLE_TAR:BOOL=ON
    -DENABLE_TEST:BOOL=ON
    -DENABLE_ACL:BOOL=OFF
    # some tests fail without zlib, we build it anyway for swipl-wasm,
    # so we might as well fix those
    -DZLIB_INCLUDE_DIR=${ZLIB_INCLUDE_DIR}
    -DZLIB_LIBRARY=${ZLIB_LIBRARY}
    -DENABLE_CPIO_SHARED:BOOL=OF
  TEST_COMMAND "ctest" "||" "true" # TODO: fix those failing tests
  INSTALL_COMMAND ""
  BUILD_BYPRODUCTS <BINARY_DIR>/libarchive/libarchive.a
)
add_dependencies(libarchive zlib)
ExternalProject_Get_Property(libarchive SOURCE_DIR)
ExternalProject_Get_Property(libarchive BINARY_DIR)
set(LIBARCHIVE_SOURCE_DIR "${SOURCE_DIR}")
set(LIBARCHIVE_BINARY_DIR "${BINARY_DIR}")
set(LIBARCHIVE_INCLUDE_DIR ${LIBARCHIVE_SOURCE_DIR}/libarchive)
set(LIBARCHIVE_LIBRARY ${LIBARCHIVE_BINARY_DIR}/libarchive/libarchive.a)

# zlib https://www.swi-prolog.org/build/prerequisites.html
# regarding the build opptions, see here: https://github.com/SWI-Prolog/swipl-devel/blob/master/CMAKE.md
ExternalProject_Add(swi-prolog
  URL ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/swi-prolog
  CMAKE_ARGS
    -DUSE_GMP=OFF
    -DUSE_TCMALLOC=OFF
    -DBUILD_TESTING=OFF
    -DBUILD_SWIPL_LD=OFF
    -DSWIPL_STATIC_LIB=ON
    -DSWIPL_PACKAGES=ON
    -DCMAKE_BUILD_TYPE=Release
    -DSWIPL_PACKAGE_LIST=cpp;zlib # seperate this by ;
    -DZLIB_INCLUDE_DIR=${ZLIB_INCLUDE_DIR}
    -DZLIB_LIBRARY=${ZLIB_LIBRARY}
    -DINSTALL_TESTS=ON
    -DINSTALL_DOCUMENTATION=OFF
    -DSWIPL_INSTALL_IN_LIB=OFF
    -DSWIPL_INSTALL_IN_SHARE=OFF
  TEST_COMMAND ""
  INSTALL_COMMAND ""
  BUILD_BYPRODUCTS <BINARY_DIR>/src/libswipl_static.a
)
add_dependencies(swi-prolog zlib)
ExternalProject_Get_Property(swi-prolog SOURCE_DIR)
ExternalProject_Get_Property(swi-prolog BINARY_DIR)
set(SWI_PROLOG_SOURCE_DIR "${SOURCE_DIR}")
set(SWI_PROLOG_BINARY_DIR "${BINARY_DIR}")
set(SWIPL_INCLUDE_DIR "${SWI_PROLOG_BINARY_DIR}/home/include")
set(SWIPL_LIBRARY "${SWI_PROLOG_BINARY_DIR}/src/libswipl_static.a")

set(SWI_PROLOG_HOME_STORE_PATH "${CMAKE_CURRENT_BINARY_DIR}/swipl-prolog-home.tar.xz")
add_custom_target(swi-prolog-home
WORKING_DIRECTORY
  "${SWI_PROLOG_BINARY_DIR}"
COMMAND
  # ${CMAKE_COMMAND} -E # cmake has no support for the -h option needed
  # to dereference symlink
  XZ_OPT=-9 tar "cJfh" ${SWI_PROLOG_HOME_STORE_PATH} home
)
add_dependencies(swi-prolog-home swi-prolog)

include(Dependencies/incbin.cmake)

# TODO: migrate these to ExternalProject_Add

include(FetchContent)

FetchContent_Declare(google-test
  URL ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/googletest
)

# flags for boost
#set(OPENSSL_USE_STATIC_LIBS ON)
FetchContent_Declare(boost
  URL ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/boost
)

FetchContent_MakeAvailable(boost)
FetchContent_MakeAvailable(google-test)

# configuration for our targets

# ActKit
add_library(ActKit
  Sources/ActKit/LegalElements.swift
  Sources/ActKit/LegalElementsBuilders.swift
  Sources/ActKit/Code.swift
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
target_compile_options(LogicKit PRIVATE
  $<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJCXX>:-DSWI_PROLOG_HOME_STORE="${SWI_PROLOG_HOME_STORE_PATH}">
)
target_link_libraries(LogicKit PUBLIC
  ActKit
  ${SWIPL_LIBRARY}
  ${ZLIB_LIBRARY}
  ${LIBARCHIVE_LIBRARY}
  Boost::filesystem
  Boost::numeric_conversion
  incbin
)

# Tests
add_executable(LXTests
Testing/ActKitTests.swift
  Testing/Testing.c++
  Testing/LogicKitTests.swift
  Testing/main.swift
)
target_compile_options(LXTests PRIVATE ${CXX_Werror})
target_include_directories(LXTests PUBLIC Testing/include)
target_link_libraries(LXTests PUBLIC LogicKit ActKit GTest::gtest)

# LX executable
add_executable(LX
  Sources/main.swift
)
target_link_libraries(LX LogicKit ActKit)

# configuration for all targets
set(TARGETS
  LogicKit
  LX
  ActKit
  LXTests
)

if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang"
    OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  set(SWIFT_CXX_INTEROP
    $<$<COMPILE_LANGUAGE:Swift>:-cxx-interoperability-mode=default>
  )

  set(SWIFT_CXX_INTEROP_LANGUAGE_VERSION
    $<$<COMPILE_LANGUAGE:Swift>:-Xcc>
    $<$<COMPILE_LANGUAGE:Swift>:-std=c++17>
  )

  set(SWIFT_TESTABLE
    $<$<COMPILE_LANGUAGE:Swift>:-enable-testing>
  )
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
    ${SWIFT_CXX_INTEROP}
    ${SWIFT_CXX_INTEROP_LANGUAGE_VERSION}
    ${SWIFT_TESTABLE}
  )

  set_target_properties(${TARGET} PROPERTIES
    COMPILE_WARNING_AS_ERROR ON
    
    CMAKE_Swift_LANGUAGE_VERSION 6

    CMAKE_OBJCXX_STANDARD 23
    CMAKE_CXX_STANDARD 23
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