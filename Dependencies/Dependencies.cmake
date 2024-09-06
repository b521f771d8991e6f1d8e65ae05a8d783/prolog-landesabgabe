# If the package is widly available in repos, use find_package,
# else or git submodules

# in system repos:
find_package(Boost REQUIRED COMPONENTS filesystem headers)
find_package(GTest REQUIRED)
find_package(ZLIB REQUIRED)
find_package(LibArchive REQUIRED)

# from git submodules:

include(Dependencies/incbin.cmake)

include(ExternalProject)

# zlib https://www.swi-prolog.org/build/prerequisites.html
# regarding the build opptions, see here: https://github.com/SWI-Prolog/swipl-devel/blob/master/CMAKE.md
ExternalProject_Add(swi-prolog
  URL ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/swi-prolog
  CMAKE_ARGS
    -DUSE_GMP=OFF
    -DUSE_TCMALLOC=OFF
    -DBUILD_TESTING=ON
    -DBUILD_SWIPL_LD=OFF
    -DSWIPL_STATIC_LIB=ON
    -DSWIPL_PACKAGES=ON
    -DINSTALL_DOCUMENTATION=OFF # we get strange ninja errors without that
    -DSWIPL_PACKAGE_LIST=cpp;zlib # seperate this by ;
    -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/root
BUILD_BYPRODUCTS ${CMAKE_CURRENT_BINARY_DIR}/root/lib/swipl/lib/x86_64-linux/libswipl_static.a
)

set(SWI_PROLOG_HOME_STORE_PATH "${CMAKE_CURRENT_BINARY_DIR}/swipl-prolog-home.tar.xz")
add_custom_target(swi-prolog-home
WORKING_DIRECTORY
  "${CMAKE_CURRENT_BINARY_DIR}/root/lib/swipl"
COMMAND
  # ${CMAKE_COMMAND} -E # cmake has no support for the -h option needed
  # to dereference symlink
  XZ_OPT=-9 tar "cJfh" ${SWI_PROLOG_HOME_STORE_PATH} .
)
add_dependencies(swi-prolog-home swi-prolog)

set(DEPENDENCY_INCLUDE_DIRS "${CMAKE_CURRENT_BINARY_DIR}/root/lib/swipl/include")
set(DEPENDENCY_LIBRARIES_DIRS "${CMAKE_CURRENT_BINARY_DIR}/root/lib/swipl/lib/x86_64-linux/libswipl_static.a")