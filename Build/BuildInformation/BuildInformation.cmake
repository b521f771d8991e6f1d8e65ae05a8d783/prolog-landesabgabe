find_program(GIT NAMES git REQUIRED)

execute_process(
  COMMAND ${GIT} rev-parse HEAD
  OUTPUT_VARIABLE GIT_HASH
  OUTPUT_STRIP_TRAILING_WHITESPACE
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

execute_process(
  COMMAND ${GIT} rev-parse --abbrev-ref HEAD
  OUTPUT_VARIABLE GIT_BRANCH
  OUTPUT_STRIP_TRAILING_WHITESPACE
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

execute_process(
  COMMAND ${GIT} diff --quiet
  RESULT_VARIABLE GIT_STATUS
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

if(NOT GIT_STATUS EQUAL 0)
  set(GIT_DIRTY "true")
else()
  set(GIT_DIRTY "false")
endif()

string(TIMESTAMP BUILD_DAY "%d")
string(TIMESTAMP BUILD_MONTH "%m")
string(TIMESTAMP BUILD_YEAR "%Y")
set(BUILD_TYPE "${CMAKE_BUILD_TYPE}")

execute_process(COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_CURRENT_LIST_DIR}/BuildInformation.h.in)
execute_process(COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_CURRENT_LIST_DIR}/BuildInformation.c++.in)

configure_file(
  ${CMAKE_CURRENT_LIST_DIR}/BuildInformation.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/BuildInformation/BuildInformation.h
  @ONLY
)

configure_file(
  ${CMAKE_CURRENT_LIST_DIR}/BuildInformation.c++.in
  ${CMAKE_CURRENT_BINARY_DIR}/BuildInformation/BuildInformation.c++
  @ONLY
)

execute_process(
  COMMAND ${CMAKE_COMMAND}
          -E copy ${CMAKE_CURRENT_LIST_DIR}/module.modulemap
          ${CMAKE_CURRENT_BINARY_DIR}/BuildInformation
)

add_library(BuildInformation
  ${CMAKE_CURRENT_BINARY_DIR}/BuildInformation/BuildInformation.c++
)
target_include_directories(BuildInformation
PUBLIC
${CMAKE_CURRENT_BINARY_DIR}/BuildInformation
)