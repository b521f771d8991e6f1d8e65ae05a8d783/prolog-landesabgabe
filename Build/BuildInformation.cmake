execute_process(
  COMMAND git rev-parse HEAD
  OUTPUT_VARIABLE GIT_HASH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

execute_process(
  COMMAND git diff --quiet
  RESULT_VARIABLE GIT_STATUS
)

if(NOT GIT_STATUS EQUAL 0)
  set(GIT_HASH "${GIT_HASH}-dirty")
endif()

string(TIMESTAMP BUILD_DAY "%d")
string(TIMESTAMP BUILD_MONTH "%m")
string(TIMESTAMP BUILD_YEAR "%Y")
set(BUILD_TYPE "${CMAKE_BUILD_TYPE}")

execute_process(COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_CURRENT_SOURCE_DIR}/Build/BuildInformation.h.in)
execute_process(COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_CURRENT_SOURCE_DIR}/Build/BuildInformation.c++.in)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/Build/BuildInformation.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/BuildInformation/BuildInformation.h
  @ONLY
)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/Build/BuildInformation.c++.in
  ${CMAKE_CURRENT_BINARY_DIR}/BuildInformation/BuildInformation.c++
  @ONLY
)

execute_process(COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/Build/module.modulemap  ${CMAKE_CURRENT_BINARY_DIR}/BuildInformation)

add_library(BuildInformation
  ${CMAKE_CURRENT_BINARY_DIR}/BuildInformation/BuildInformation.c++
)
target_include_directories(BuildInformation
PUBLIC
  ${CMAKE_CURRENT_BINARY_DIR}/BuildInformation/
)