# ${CMAKE_COMMAND} -E # cmake has no support for the -h option needed
# to dereference symlink

find_program(tar tar)
find_program(rm rm)
find_program(mkdir mkdir)

set(lxui_tar_path "${CMAKE_CURRENT_BINARY_DIR}/lxui.tar")
add_custom_target(lxui_tar
WORKING_DIRECTORY
  "${CMAKE_CURRENT_LIST_DIR}/../lxui"
COMMAND
  ${rm} -f ${lxui_tar_path} && ${tar} "cfh" ${lxui_tar_path} dist
)

set(corpus_tar_path "${CMAKE_CURRENT_BINARY_DIR}/corpus.tar")
add_custom_target(corpus_tar
WORKING_DIRECTORY
  "${CMAKE_CURRENT_LIST_DIR}/../"
COMMAND
  ${rm} -f ${corpus_tar_path} && ${tar} "cfh" ${corpus_tar_path} Corpus
)

# Repack it
set(assets_tar_path "${CMAKE_CURRENT_BINARY_DIR}/assets.tar")
add_custom_target(assets_tar
WORKING_DIRECTORY
  "${CMAKE_CURRENT_BINARY_DIR}"
COMMAND
  ${rm} ${assets_tar_path} -rf tmp_dir
  && ${mkdir} tmp_dir
  && cd tmp_dir
  && ${tar} "xf" ${lxui_tar_path}
  && ${tar} "xf" ${corpus_tar_path}
  && ${tar} "cfh" ${assets_tar_path} .
  && cd ..
  && ${rm} -rf tmp_dir
)
add_dependencies(assets_tar 
    lxui_tar
    corpus_tar
)

add_library(Assets STATIC assets.c assets.c++)
add_dependencies(Assets assets_tar)
target_include_directories(Assets PUBLIC include)
target_link_libraries(Assets PUBLIC
  LibArchive::LibArchive
)
target_compile_definitions(Assets PRIVATE
  ASSETS_TAR_PATH="${assets_tar_path}"
)

add_executable(test_assets
  Testing/test_get_from_assets.c++
)
target_link_libraries(test_assets PUBLIC
  Assets
  GTest::gtest_main
)

add_test(
  NAME test_assets
  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/test_assets
)