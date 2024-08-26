cmake_minimum_required(VERSION 3.28)
project(LX VERSION 1.0 LANGUAGES Swift CXX C)

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

  set(CXX_WALL
    $<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJCXX>:-Wall>
  )

  set(CXX_Wextra
    $<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJCXX>:-Wall>
  )

  set(CXX_Werror
    $<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJCXX>:-Werror>
  )

  set(CXX_pedantic
    $<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJCXX>:-pedantic>
  )

  set(CXX_FPIC
    $<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJCXX>:-fPIC>
  )

  set(CXX_SANITIZE
    #$<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJCXX>:-fsanitize=address>
  )
else()
  message("This program should be compiled with clang or gcc")
endif()

add_compile_options(
  ${SWIFT_CXX_INTEROP}
  ${SWIFT_CXX_INTEROP_LANGUAGE_VERSION}
  ${SWIFT_TESTABLE}
  ${CXX_WALL}
  ${CXX_Wextra}
  ${CXX_pedantic}
  ${CXX_FPIC}
  ${CXX_SANITIZE}
)

add_link_options(
  #-lasan
)

set(CMAKE_Swift_LANGUAGE_VERSION 5)

set(CMAKE_OBJCXX_STANDARD 17)
set(CMAKE_OBJCXX_STANDARD_REQUIRED ON)
set(CMAKE_OBJCXX_EXTENSIONS OFF)

set(CMAKE_OBJC_STANDARD 17)
set(CMAKE_OBJC_STANDARD_REQUIRED ON)
set(CMAKE_OBJC_EXTENSIONS OFF)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

include(ExternalProject)

ExternalProject_Add(zlib # swi-prolog needs that and does not ship it itself 😒
  URL ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/zlib
  CONFIGURE_COMMAND "CFLAGS=-fPIC" "<SOURCE_DIR>/configure" "-static"
  BUILD_COMMAND     "make"
  INSTALL_COMMAND ""
#  TEST_COMMAND "make" "test" TODO: do this correctly on wasm/do not do this at wasm at all, only on traditional platforms
  BUILD_BYPRODUCTS  <BINARY_DIR>/libz.a
)
ExternalProject_Get_Property(zlib SOURCE_DIR)
ExternalProject_Get_Property(zlib BINARY_DIR)
set(ZLIB_SOURCE_DIR "${SOURCE_DIR}")
set(ZLIB_BINARY_DIR "${BINARY_DIR}")

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
    -DZLIB_LIBRARY=${ZLIB_BINARY_DIR}/libz.a
    -DZLIB_INCLUDE_DIR=${ZLIB_SOURCE_DIR}
    #-DOPENSSL_INCLUDE_DIR=${OPENSSL_BINARY_DIR}/include
    #-DOPENSSL_SSL_LIBRARY=${OPENSSL_BINARY_DIR}/libssl.a
    #-DOPENSSL_CRYPTO_LIBRARY=${OPENSSL_BINARY_DIR}/libcrypto.a
    -DINSTALL_TESTS=OFF
    -DINSTALL_DOCUMENTATION=OFF
    -DSWIPL_INSTALL_IN_LIB=OFF
    -DSWIPL_INSTALL_IN_SHARE=OFF
  INSTALL_COMMAND ""
  BUILD_BYPRODUCTS <BINARY_DIR>/src/libswipl_static.a
)
ExternalProject_Get_Property(swi-prolog SOURCE_DIR)
ExternalProject_Get_Property(swi-prolog BINARY_DIR)
set(SWI_PROLOG_SOURCE_DIR "${SOURCE_DIR}")
set(SWI_PROLOG_BINARY_DIR "${BINARY_DIR}")

include(FetchContent)

FetchContent_Declare(google-test
  URL ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/googletest
)

# flags for boost
#set(OPENSSL_USE_STATIC_LIBS ON)i
#set(OPENSSL_SSL_LIBRARY ${OPENSSL_BINARY_DIR}/libssl.a)
#set(OPENSSL_CRYPTO_LIBRARY ${OPENSSL_BINARY_DIR}/libcrypto.a)
#set(OPENSSL_INCLUDE_DIR ${OPENSSL_BINARY_DIR}/include)
#FetchContent_Declare(boost
#  URL ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/boost
#)

FetchContent_MakeAvailable(google-test)

# ActKit
add_library(ActKit
  Sources/ActKit/LegalElements.swift
  Sources/ActKit/LegalElementsBuilders.swift
  Sources/ActKit/Code.swift
)

# LogicKit
add_library(LogicKit
  Sources/LogicKit/Norm.swift
  Sources/LogicKit/LogicKit.c++
  Sources/LogicKit/TemplateEngine.swift
  Sources/LogicKit/LegalStatement.swift
  Sources/LogicKit/StdStatements.swift
)
add_dependencies(LogicKit swi-prolog zlib)
target_include_directories(LogicKit PUBLIC
  Sources/LogicKit/include
  "${SWI_PROLOG_BINARY_DIR}/home/include"
)
target_compile_options(LogicKit PRIVATE ${CXX_Werror})
target_link_libraries(LogicKit PUBLIC
  ActKit
  ${SWI_PROLOG_BINARY_DIR}/src/libswipl_static.a
  ${ZLIB_BINARY_DIR}/libz.a
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
target_link_libraries(LXTests PUBLIC LogicKit ActKit gtest)

# LX executable
add_executable(LX
  Sources/main.swift
)
target_link_libraries(LX LogicKit ActKit)

find_program(CLANG_TIDY_EXE NAMES "clang-tidy")
set(CLANG_TIDY_COMMAND "${CLANG_TIDY_EXE}")
set(CLANG_TIDY_OPTIONS "-checks=-*,bugprone-*,objc-*,cert-*,clang-analyzer-*,darwin-*,hicpp-*,performance-*,portability-*")
set_target_properties(LogicKit LXTests PROPERTIES
  OBJCXX_CLANG_TIDY "${CLANG_TIDY_EXE};${CLANG_TIDY_OPTIONS}"
  OBJC_CLANG_TIDY "${CLANG_TIDY_EXE};${CLANG_TIDY_OPTIONS}"
  CXX_CLANG_TIDY "${CLANG_TIDY_EXE};${CLANG_TIDY_OPTIONS}"
  C_CLANG_TIDY "${CLANG_TIDY_EXE};${CLANG_TIDY_OPTIONS}"
)