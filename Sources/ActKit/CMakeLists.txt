# ActKit
add_library(ActKit
  LegalElements.swift
  LegalElementsBuilders.swift
  Code.swift
)

add_executable(ActKitTests
  Testing/Tests.swift
)
target_link_libraries(ActKitTests PUBLIC
  ActKit
)

add_test(
  NAME ActKitTests
  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/ActKitTests
)