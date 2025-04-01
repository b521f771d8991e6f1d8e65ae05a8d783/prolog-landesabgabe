#add_executable(LogicKitTests
#  Testing/Testing.c++
#)
#target_include_directories(LogicKitTests
#PUBLIC
#  Testing/include
#)
#target_link_libraries(LogicKitTests
#PUBLIC
#  GTest::GTest
#  Boost::numeric_conversion
#  LogicKit
#  BuildInformation
#  ${DEPENDENCY_LIBRARIES_DIRS} # why do we need this?
#)
#
#add_test(
#  NAME LogicKitTests
#  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/LogicKitTests
#)