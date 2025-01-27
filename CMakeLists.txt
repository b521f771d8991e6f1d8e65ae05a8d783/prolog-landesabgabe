cmake_minimum_required(VERSION 3.28)
project(LX LANGUAGES Swift CXX C)

include(CTest)
include(Build/BuildInformation.cmake)
include(Dependencies/Dependencies.cmake)

# configuration for our targets

add_subdirectory(Sources/ActKit)
add_subdirectory(Sources/LogicKit)

# configuration for all targets
set(TARGETS
  ActKit
  LogicKit
)

set(TEST_TARGETS
  ActKitTests
  LogicKitTests
)

# add target configuration
if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang"
    OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  set(SWIFT_TESTABLE
    $<$<COMPILE_LANGUAGE:Swift>:-enable-testing>
  )

  set(Wall "$<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-Wall>")
  set(Wextra "$<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-Wextra>")
  set(Wpedantic "$<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-Wpedantic>")
  set(Werror "$<$<COMPILE_LANGUAGE:C,CXX,OBJC,OBJXX>:-Werror>")
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

foreach(TARGET ${TARGETS} ${TEST_TARGETS})
  target_compile_options(${TARGET} PRIVATE
    ${SWIFT_TESTABLE}
    ${Wall}
    ${Wextra}
    ${Werror}
    ${Wpedantic}
  )

  set_target_properties(${TARGET} PROPERTIES
    COMPILE_WARNING_AS_ERROR ON
    
    CMAKE_Swift_LANGUAGE_VERSION 6

    CMAKE_OBJCXX_STANDARD 20
    CMAKE_CXX_STANDARD 20
    CMAKE_OBJC_STANDARD 17
    CMAKE_C_STANDARD 17

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

# SPM-Targets
set(ALL_TARGET_DEPENDECIES)

foreach(lib ${TARGETS})
  get_target_property(INTERFACE_LINK ${lib} INTERFACE_LINK_LIBRARIES)
  get_target_property(LINK ${lib} LINK_LIBRARIES)
  
  if(LINK)
    foreach(CURRENT ${LINK})
      list(APPEND ALL_TARGET_DEPENDECIES ${CURRENT})
    endforeach()
  endif()
endforeach()

set(SWIFTC_DEPENDENCY_LIBRARIES)
foreach(lib ${ALL_TARGET_DEPENDECIES})
  if(IS_ABSOLUTE ${lib})
    list(APPEND SWIFTC_DEPENDENCY_LIBRARIES -Xswiftc "-l${lib}")
    list(APPEND SWIFTC_DEPENDENCY_LIBRARIES -Xcc "-l${lib}")
    list(APPEND SWIFTC_DEPENDENCY_LIBRARIES -Xcxx "-l${lib}")
  else()
    if((NOT ${lib} STREQUAL "Boost::headers")
      AND (NOT ${lib} STREQUAL "nlohmann_json::nlohmann_json")
      AND (NOT ${lib} STREQUAL "tl::expected")) # TODO filter this out properly
      list(APPEND SWIFTC_DEPENDENCY_LIBRARIES -Xswiftc "-l$<TARGET_LINKER_FILE:${lib}>")
      list(APPEND SWIFTC_DEPENDENCY_LIBRARIES -Xcc "-l$<TARGET_LINKER_FILE:${lib}>")
      list(APPEND SWIFTC_DEPENDENCY_LIBRARIES -Xcxx "-l$<TARGET_LINKER_FILE:${lib}>")
    endif()
  endif()
endforeach()

string(TOLOWER "${CMAKE_BUILD_TYPE}" SWIFT_BUILD_TYPE)

find_program(CARGO_EXE NAMES "cargo" REQUIRED)

if(${CMAKE_BUILD_TYPE} STREQUAL "Release")
  set(CARGO_FLAGS --release)
else()
  set(CARGO_FLAGS)
endif()

add_custom_target(CargoPackage
  COMMAND
    ${CARGO_EXE} "build" ${CARGO_FLAGS}
  WORKING_DIRECTORY
    ${CMAKE_CURRENT_SOURCE_DIR}
)

add_custom_target(SwiftPackage
  COMMAND
    "CC=${CMAKE_C_COMPILER}"
    "CXX=${CMAKE_CXX_COMPILER}"
    ${SWIFT_EXE} "build"
    -v
    --configuration ${SWIFT_BUILD_TYPE}
    --package-path ${CMAKE_CURRENT_SOURCE_DIR}
    -Xswiftc -I${CMAKE_CURRENT_BINARY_DIR}/Sources/ActKit
    -Xswiftc -I${CMAKE_CURRENT_BINARY_DIR}/Sources/LogicKit
    -Xswiftc -I${CMAKE_CURRENT_BINARY_DIR}/BuildInformation
    -Xswiftc -I${CMAKE_CURRENT_BINARY_DIR}
    -Xswiftc -L${CMAKE_CURRENT_BINARY_DIR}/Sources/ActKit
    -Xswiftc -L${CMAKE_CURRENT_BINARY_DIR}/Sources/LogicKit
    -Xswiftc -L${CMAKE_CURRENT_BINARY_DIR}/BuildInformation
    -Xswiftc -L${CMAKE_CURRENT_BINARY_DIR}
    -Xswiftc -F${CMAKE_CURRENT_SOURCE_DIR}/Sources/LogicKit/include
    -Xswiftc -I${CMAKE_CURRENT_SOURCE_DIR}/Sources/LogicKit/include
    -Xswiftc -L${CMAKE_CURRENT_SOURCE_DIR}/Sources/LogicKit/include
    ${SWIFTC_DEPENDENCY_LIBRARIES}
)
add_dependencies(SwiftPackage ${TARGETS} CargoPackage)