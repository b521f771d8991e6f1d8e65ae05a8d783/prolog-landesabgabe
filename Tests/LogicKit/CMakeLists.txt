add_executable(test_logic_kit
  test_prolog_vm.c++
)
target_link_libraries(test_logic_kit
PUBLIC
  GTest::GTest
  Boost::numeric_conversion
  LogicKit
  BuildInformation
  Assets
  ${DEPENDENCY_LIBRARIES_DIRS}
)

add_test(
  NAME test_logic_kit
  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/test_logic_kit
)