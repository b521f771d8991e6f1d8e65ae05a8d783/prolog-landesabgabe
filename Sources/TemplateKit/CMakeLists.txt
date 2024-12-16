add_library(TemplateKit
    TemplateKit.swift
    LabggTemplates.swift
)

add_executable(TemplateKitTests
    Testing/Tests.swift
)
target_link_libraries(TemplateKitTests PUBLIC
    TemplateKit
)

add_test(
  NAME TemplateKitTests
  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/TemplateKitTests
)