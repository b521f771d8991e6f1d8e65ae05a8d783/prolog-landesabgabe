# ${CMAKE_COMMAND} -E # cmake has no support for the -h option needed
# to dereference symlink

set(swi_prolog_home_store_path "${CMAKE_CURRENT_BINARY_DIR}/swipl-prolog-home.tar")
add_custom_target(swi_prolog_home_tar
WORKING_DIRECTORY
  "${CMAKE_BINARY_DIR}/root/lib/swipl"
COMMAND
  tar "cfh" ${swi_prolog_home_store_path} .
)
add_dependencies(swi_prolog_home_tar swi-prolog)

set(lxui_home_tar_path "${CMAKE_CURRENT_BINARY_DIR}/lxui.tar")
add_custom_target(lxui_tar
WORKING_DIRECTORY
  "${CMAKE_CURRENT_LIST_DIR}/../lxui/dist"
COMMAND
  tar "cfh" ${lxui_home_tar_path} .
)

set(corpus_tar_path "${CMAKE_CURRENT_BINARY_DIR}/corpus.tar")
add_custom_target(corpus_tar
WORKING_DIRECTORY
  "${CMAKE_CURRENT_LIST_DIR}/../Corpus"
COMMAND
  tar "cfh" ${corpus_tar_path} .
)

add_library(Assets STATIC assets.c assets.c++)
add_dependencies(Assets 
    swi_prolog_home_tar
    lxui_tar
    corpus_tar
)
target_include_directories(Assets PUBLIC include)
target_link_libraries(Assets PUBLIC
  LibArchive::LibArchive
  Boost::filesystem
)
target_compile_definitions(Assets PRIVATE
  CORPUS_TAR="${corpus_tar_path}"
  SWI_PROLOG_HOME_TAR="${swi_prolog_home_store_path}"
  LX_UI_HOME_TAR="${lxui_home_tar_path}"
)