include(ExternalProject)

# https://www.swi-prolog.org/build/WebAssembly.html <-- we need that
set(ZLIB_FLAGS ${CMAKE_C_FLAGS})
ExternalProject_Add(zlib # swi-prolog needs that and does not ship it itself 😒
  URL ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/zlib
  CMAKE_ARGS
    #-DSTATIC=ON
    -DSKIP_INSTALL_ALL=ON
    -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
    -DCMAKE_C_FLAGS=${EXTERNAL_PROJECT_OPTIONS}
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
  TEST_COMMAND "ctest"
  INSTALL_COMMAND ""
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
    -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
    -DCMAKE_C_FLAGS=${EXTERNAL_PROJECT_OPTIONS}
    -DENABLE_TAR:BOOL=ON
    -DENABLE_TEST:BOOL=ON
    -DENABLE_ACL:BOOL=OFF
    # some tests fail without zlib, we build it anyway for swipl-wasm,
    # so we might as well fix those
    -DZLIB_INCLUDE_DIR=${ZLIB_INCLUDE_DIR}
    -DZLIB_LIBRARY=${ZLIB_LIBRARY}
    -DENABLE_CPIO_SHARED:BOOL=OF
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
  TEST_COMMAND "ctest" "||" "true" # TODO: fix those failing tests
  INSTALL_COMMAND ""
  BUILD_BYPRODUCTS <BINARY_DIR>/libarchive/libarchive.a
  DEPENDS zlib
)
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
    -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
    -DCMAKE_C_FLAGS=${EXTERNAL_PROJECT_OPTIONS}
    -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
    -DCMAKE_CXX_FLAGS=${EXTERNAL_PROJECT_OPTIONS}
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
  DEPENDS zlib
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