find_package(Boost REQUIRED COMPONENTS filesystem headers)
find_package(GTest REQUIRED)
find_package(ZLIB REQUIRED)
find_package(LibArchive REQUIRED)

include(ExternalProject)

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
    -DSWIPL_PACKAGE_LIST=cpp # seperate this by ;
    -DINSTALL_TESTS=OFF
    -DINSTALL_DOCUMENTATION=OFF
    -DSWIPL_INSTALL_IN_LIB=OFF
    -DSWIPL_INSTALL_IN_SHARE=OFF
  TEST_COMMAND ""
  INSTALL_COMMAND ""
  BUILD_BYPRODUCTS <BINARY_DIR>/src/libswipl_static.a
)
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