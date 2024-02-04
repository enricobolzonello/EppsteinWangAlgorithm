include(GenerateExportHeader)


add_library(graph graph.cpp)



add_library(EppsteinWangAlgorithm::graph ALIAS graph)

target_link_libraries(graph PRIVATE EppsteinWangAlgorithm_options EppsteinWangAlgorithm_warnings)

target_include_directories(graph ${WARNING_GUARD} PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
                                                                  $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>)

target_compile_features(graph PUBLIC cxx_std_20)

set_target_properties(
  graph
  PROPERTIES VERSION ${PROJECT_VERSION}
             CXX_VISIBILITY_PRESET hidden
             VISIBILITY_INLINES_HIDDEN YES)

generate_export_header(graph EXPORT_FILE_NAME ${PROJECT_BINARY_DIR}/include/EppsteinWangAlgorithm/sample_library_export.hpp)

if(NOT BUILD_SHARED_LIBS)
  target_compile_definitions(graph PUBLIC SAMPLE_LIBRARY_STATIC_DEFINE)
endif()
