set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

# see https://best.openssf.org/Compiler-Hardening-Guides/Compiler-Options-Hardening-Guide-for-C-and-C++.html
# https://www.phoronix.com/news/GCC-fhardened-Hardening-Option

# Set the compiler and its path
find_program(CC_EXE NAMES "clang-18" "clang")
find_program(CXX_EXE NAMES "clang-18" "clang++")
find_program(SWIFTC_EXE NAMES "swiftc")

set(CMAKE_C_COMPILER "${CC_EXE}")
set(CMAKE_CXX_COMPILER "${CXX_EXE}")
set(CMAKE_OBJC_COMPILER "${CC_EXE}")
set(CMAKE_OBJCXX_COMPILER "${CXX_EXE}")
set(CMAKE_Swift_COMPILER "${SWIFTC_EXE}")

#set(CMAKE_C_COMPILER_TARGET x86_64-unknown-linux-musl)
#set(CMAKE_CXX_COMPILER_TARGET ${CMAKE_C_COMPILER_TARGET})
#set(CMAKE_OBJC_COMPILER_TARGET ${CMAKE_C_COMPILER_TARGET})
#set(CMAKE_OBJCXX_COMPILER_TARGET ${CMAKE_C_COMPILER_TARGET})
#set(CMAKE_Swift_COMPILER_TARGET ${CMAKE_C_COMPILER_TARGET})

# flags for all files, including dependencies (DO NOT do -Werror here, it would break dependencies)
set(EXTERNAL_PROJECT_OPTIONS -fPIC)
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


# vcpkg configuration

set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CMAKE_SYSTEM_NAME linux)
set(VCPKG_LIBRARY_LINKAGE static)

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

include(/workspace/Dependencies/vcpkg/scripts/buildsystems/vcpkg.cmake)