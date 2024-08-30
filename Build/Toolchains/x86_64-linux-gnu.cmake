set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

# Set the compiler and its path
find_program(GCC_EXE NAMES "gcc")
find_program(GXX_EXE NAMES "g++")
find_program(SWIFTC_EXE NAMES "swiftc")

set(CMAKE_C_COMPILER "${GCC_EXE}")
set(CMAKE_CXX_COMPILER "${GXX_EXE}")
set(CMAKE_OBJC_COMPILER "${GCC_EXE}")
set(CMAKE_OBJCXX_COMPILER "${GXX_EXE}")
set(CMAKE_Swift_COMPILER "${SWIFTC_EXE}")

# Set the flags for the newest preprocessor instructions
set(CMAKE_C_FLAGS "-march=native -mtune=native -O3 -Wall -Wextra -Wpedantic -fhardened")
set(CMAKE_CXX_FLAGS "-march=native -mtune=native -O3 -Wall -Wextra -Wpedantic -fhardened")
set(CMAKE_OBJC_FLAGS "${CMAKE_C_CFLAGS}")
set(CMAKE_OBJCXX_FLAGS "${CMAKE_CXX_CFLAGS}")
set(CMAKE_Swift_FLAGS "-cxx-interoperability-mode=default")