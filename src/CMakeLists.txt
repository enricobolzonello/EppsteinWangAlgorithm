add_subdirectory(graph)

add_executable(temp_test test.cpp)
target_link_libraries(
  temp_test PUBLIC EppsteinWangAlgorithm::graph)

add_executable(eppsteinwang EppsteinWang.cpp)
target_link_libraries(
  eppsteinwang PUBLIC EppsteinWangAlgorithm::graph)

  target_include_directories(eppsteinwang ${WARNING_GUARD} PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
  $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>)