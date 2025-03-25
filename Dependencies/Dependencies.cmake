# If the package is widly available in repos, use find_package,
# else or git submodules

# in system repos:
find_package(Boost REQUIRED COMPONENTS filesystem numeric_conversion)
find_package(GTest REQUIRED)
find_package(ZLIB REQUIRED)
find_package(LibArchive REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(Curses REQUIRED)

# from git submodules:

include(ExternalProject)

# zlib https://www.swi-prolog.org/build/prerequisites.html
# regarding the build opptions, see here: https://github.com/SWI-Prolog/swipl-devel/blob/master/CMAKE.md
ExternalProject_Add(swi-prolog
  URL ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/swi-prolog
  CMAKE_ARGS
    -DUSE_GMP=OFF
    -DUSE_TCMALLOC=OFF
    -DBUILD_SWIPL_LD=OFF
    -DSWIPL_STATIC_LIB=ON
    #-DSTATIC_EXTENSIONS=ON
    -DSWIPL_PACKAGES=ON
    -DINSTALL_DOCUMENTATION=OFF # we get strange ninja errors without that
    -DBUILD_TESTING=OFF
    -DINSTALL_TESTS=OFF
    -DCMAKE_BUILD_TYPE=Release
    -DSWIPL_PACKAGE_LIST=cpp;zlib # seperate this by ;
    -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/root
  BUILD_BYPRODUCTS 
    ${CMAKE_CURRENT_BINARY_DIR}/root/lib/swipl/lib/x86_64-linux/libswipl_static.a
)

set(DEPENDENCY_INCLUDE_DIRS
  "${CMAKE_CURRENT_BINARY_DIR}/root/lib/swipl/include"
  ${CURSES_INCLUDE_DIRS}
)

set(DEPENDENCY_LIBRARIES_DIRS
  "${CMAKE_CURRENT_BINARY_DIR}/root/lib/swipl/lib/x86_64-linux/libswipl_static.a"
  ${CURSES_LIBRARIES}
)