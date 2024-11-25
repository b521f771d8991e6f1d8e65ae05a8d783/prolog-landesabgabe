# zip and include the legal material
set(CORPUS_STORE_PATH "${CMAKE_CURRENT_BINARY_DIR}/corpus.tar")
add_custom_target(corpus
WORKING_DIRECTORY
  "${CMAKE_CURRENT_LIST_DIR}"
COMMAND
  tar "cfh" ${SWI_PROLOG_HOME_STORE_PATH} .
)