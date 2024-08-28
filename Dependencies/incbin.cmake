add_library(incbin STATIC
    ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/incbin/incbin.c
)
target_include_directories(incbin PUBLIC Dependencies/incbin)
set_target_properties(incbin PROPERTIES
    CMAKE_C_STANDARD 90
    CMAKE_C_STANDARD_REQUIRED ON
    CMAKE_C_EXTENSIONS OFF
  )