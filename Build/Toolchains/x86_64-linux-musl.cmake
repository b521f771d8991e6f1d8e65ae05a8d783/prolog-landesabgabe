set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

# see https://best.openssf.org/Compiler-Hardening-Guides/Compiler-Options-Hardening-Guide-for-C-and-C++.html
# https://www.phoronix.com/news/GCC-fhardened-Hardening-Option

# Set the compiler and its path
find_program(CC_EXE NAMES "clang")
find_program(CXX_EXE NAMES "clang++")
find_program(SWIFTC_EXE NAMES "swiftc")
find_program(LINK_EXE NAMES "ld")

set(CMAKE_C_COMPILER "${CC_EXE}")
set(CMAKE_CXX_COMPILER "${CXX_EXE}")
set(CMAKE_OBJC_COMPILER "${CC_EXE}")
set(CMAKE_OBJCXX_COMPILER "${CXX_EXE}")
set(CMAKE_Swift_COMPILER "${SWIFTC_EXE}")

#set(CMAKE_C_LINK_EXECUTABLE "${LINK_EXE}")
#set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_LINKER> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
#set(CMAKE_OBJC_LINK_EXECUTABLE "${LINK_EXE}")
#set(CMAKE_OBJCXX_LINK_EXECUTABLE "${LINK_EXE}")
#set(CMAKE_Swift_LINK_EXECUTABLE "<CMAKE_LINKER> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")

# Set the flags for the newest preprocessor instructions
set(CMAKE_C_FLAGS "-march=native -mtune=native -m64 -O3 -Wall -Wextra -Wpedantic -fPIC")
set(CMAKE_CXX_FLAGS "-march=native -mtune=native -m64 -O3 -Wall -Wextra -Wpedantic -fPIC")
set(CMAKE_OBJC_FLAGS "${CMAKE_C_CFLAGS}")
set(CMAKE_OBJCXX_FLAGS "${CMAKE_CXX_CFLAGS}")
set(CMAKE_Swift_FLAGS "-cxx-interoperability-mode=default")