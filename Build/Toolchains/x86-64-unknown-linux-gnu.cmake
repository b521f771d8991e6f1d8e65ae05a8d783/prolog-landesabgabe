set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

# Set the compiler and its path
find_program(CLANG_EXE NAMES $ENV{CC} "clang" "gcc" "cc" REQUIRED)
find_program(CLANGXX_EXE NAMES $ENV{CXX} "clang++" "g++" "c++" REQUIRED)
find_program(SWIFTC_EXE NAMES "swiftc" REQUIRED)
find_program(SWIFT_EXE NAMES "swift" REQUIRED)

set(CMAKE_C_COMPILER "${CLANG_EXE}")
set(CMAKE_CXX_COMPILER "${CLANGXX_EXE}")
set(CMAKE_OBJC_COMPILER "${CLANG_EXE}")
set(CMAKE_OBJCXX_COMPILER "${CLANGXX_EXE}")
set(CMAKE_Swift_COMPILER "${SWIFTC_EXE}")

set(CMAKE_C_COMPILER_TARGET x86_64-unknown-linux-gnu)
set(CMAKE_CXX_COMPILER_TARGET ${CMAKE_C_COMPILER_TARGET})
set(CMAKE_OBJC_COMPILER_TARGET ${CMAKE_C_COMPILER_TARGET})
set(CMAKE_OBJCXX_COMPILER_TARGET ${CMAKE_C_COMPILER_TARGET})
set(CMAKE_Swift_COMPILER_TARGET ${CMAKE_C_COMPILER_TARGET})

set(EXTERNAL_PROJECT_OPTIONS
    -fPIC
)
add_compile_options(
    $<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-march=native>
    $<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-mtune=native>
    $<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-m64>
    $<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-O3>
    $<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-fPIC>
    $<$<COMPILE_LANGUAGE:Swift>:-cxx-interoperability-mode=default>
    $<$<COMPILE_LANGUAGE:Swift>:-Xcc>
    $<$<COMPILE_LANGUAGE:Swift>:-std=c++20>
)

set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CMAKE_SYSTEM_NAME linux)
set(VCPKG_LIBRARY_LINKAGE static)
#  there is really no need to further complicate this by using debug versions
set(VCPKG_BUILD_TYPE release)

set(VCPKG_C_FLAGS
    -fPIC
    -m64
    -O3
    -march=native
    -mtune=native
)
set(VCPKG_CXX_FLAGS
    -fPIC
    -m64
    -O3
    -march=native
    -mtune=native
)

set(VCPKG_INSTALL_OPTIONS --debug)
include(${CMAKE_CURRENT_LIST_DIR}/../../Dependencies/vcpkg/scripts/buildsystems/vcpkg.cmake)