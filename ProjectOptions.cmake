include(cmake/SystemLink.cmake)
include(cmake/LibFuzzer.cmake)
include(CMakeDependentOption)
include(CheckCXXCompilerFlag)


macro(EppsteinWangAlgorithm_supports_sanitizers)
  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES ".*GNU.*") AND NOT WIN32)
    set(SUPPORTS_UBSAN ON)
  else()
    set(SUPPORTS_UBSAN OFF)
  endif()

  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES ".*GNU.*") AND WIN32)
    set(SUPPORTS_ASAN OFF)
  else()
    set(SUPPORTS_ASAN ON)
  endif()
endmacro()

macro(EppsteinWangAlgorithm_setup_options)
  option(EppsteinWangAlgorithm_ENABLE_HARDENING "Enable hardening" ON)
  option(EppsteinWangAlgorithm_ENABLE_COVERAGE "Enable coverage reporting" OFF)
  cmake_dependent_option(
    EppsteinWangAlgorithm_ENABLE_GLOBAL_HARDENING
    "Attempt to push hardening options to built dependencies"
    ON
    EppsteinWangAlgorithm_ENABLE_HARDENING
    OFF)

  EppsteinWangAlgorithm_supports_sanitizers()

  if(NOT PROJECT_IS_TOP_LEVEL OR EppsteinWangAlgorithm_PACKAGING_MAINTAINER_MODE)
    option(EppsteinWangAlgorithm_ENABLE_IPO "Enable IPO/LTO" OFF)
    option(EppsteinWangAlgorithm_WARNINGS_AS_ERRORS "Treat Warnings As Errors" OFF)
    option(EppsteinWangAlgorithm_ENABLE_USER_LINKER "Enable user-selected linker" OFF)
    option(EppsteinWangAlgorithm_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" OFF)
    option(EppsteinWangAlgorithm_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(EppsteinWangAlgorithm_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" OFF)
    option(EppsteinWangAlgorithm_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(EppsteinWangAlgorithm_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(EppsteinWangAlgorithm_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(EppsteinWangAlgorithm_ENABLE_CLANG_TIDY "Enable clang-tidy" OFF)
    option(EppsteinWangAlgorithm_ENABLE_CPPCHECK "Enable cpp-check analysis" OFF)
    option(EppsteinWangAlgorithm_ENABLE_PCH "Enable precompiled headers" OFF)
    option(EppsteinWangAlgorithm_ENABLE_CACHE "Enable ccache" OFF)
  else()
    option(EppsteinWangAlgorithm_ENABLE_IPO "Enable IPO/LTO" ON)
    option(EppsteinWangAlgorithm_WARNINGS_AS_ERRORS "Treat Warnings As Errors" ON)
    option(EppsteinWangAlgorithm_ENABLE_USER_LINKER "Enable user-selected linker" OFF)
    option(EppsteinWangAlgorithm_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" ${SUPPORTS_ASAN})
    option(EppsteinWangAlgorithm_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(EppsteinWangAlgorithm_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" ${SUPPORTS_UBSAN})
    option(EppsteinWangAlgorithm_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(EppsteinWangAlgorithm_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(EppsteinWangAlgorithm_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(EppsteinWangAlgorithm_ENABLE_CLANG_TIDY "Enable clang-tidy" ON)
    option(EppsteinWangAlgorithm_ENABLE_CPPCHECK "Enable cpp-check analysis" ON)
    option(EppsteinWangAlgorithm_ENABLE_PCH "Enable precompiled headers" OFF)
    option(EppsteinWangAlgorithm_ENABLE_CACHE "Enable ccache" ON)
  endif()

  if(NOT PROJECT_IS_TOP_LEVEL)
    mark_as_advanced(
      EppsteinWangAlgorithm_ENABLE_IPO
      EppsteinWangAlgorithm_WARNINGS_AS_ERRORS
      EppsteinWangAlgorithm_ENABLE_USER_LINKER
      EppsteinWangAlgorithm_ENABLE_SANITIZER_ADDRESS
      EppsteinWangAlgorithm_ENABLE_SANITIZER_LEAK
      EppsteinWangAlgorithm_ENABLE_SANITIZER_UNDEFINED
      EppsteinWangAlgorithm_ENABLE_SANITIZER_THREAD
      EppsteinWangAlgorithm_ENABLE_SANITIZER_MEMORY
      EppsteinWangAlgorithm_ENABLE_UNITY_BUILD
      EppsteinWangAlgorithm_ENABLE_CLANG_TIDY
      EppsteinWangAlgorithm_ENABLE_CPPCHECK
      EppsteinWangAlgorithm_ENABLE_COVERAGE
      EppsteinWangAlgorithm_ENABLE_PCH
      EppsteinWangAlgorithm_ENABLE_CACHE)
  endif()

  EppsteinWangAlgorithm_check_libfuzzer_support(LIBFUZZER_SUPPORTED)
  if(LIBFUZZER_SUPPORTED AND (EppsteinWangAlgorithm_ENABLE_SANITIZER_ADDRESS OR EppsteinWangAlgorithm_ENABLE_SANITIZER_THREAD OR EppsteinWangAlgorithm_ENABLE_SANITIZER_UNDEFINED))
    set(DEFAULT_FUZZER ON)
  else()
    set(DEFAULT_FUZZER OFF)
  endif()

  option(EppsteinWangAlgorithm_BUILD_FUZZ_TESTS "Enable fuzz testing executable" ${DEFAULT_FUZZER})

endmacro()

macro(EppsteinWangAlgorithm_global_options)
  if(EppsteinWangAlgorithm_ENABLE_IPO)
    include(cmake/InterproceduralOptimization.cmake)
    EppsteinWangAlgorithm_enable_ipo()
  endif()

  EppsteinWangAlgorithm_supports_sanitizers()

  if(EppsteinWangAlgorithm_ENABLE_HARDENING AND EppsteinWangAlgorithm_ENABLE_GLOBAL_HARDENING)
    include(cmake/Hardening.cmake)
    if(NOT SUPPORTS_UBSAN 
       OR EppsteinWangAlgorithm_ENABLE_SANITIZER_UNDEFINED
       OR EppsteinWangAlgorithm_ENABLE_SANITIZER_ADDRESS
       OR EppsteinWangAlgorithm_ENABLE_SANITIZER_THREAD
       OR EppsteinWangAlgorithm_ENABLE_SANITIZER_LEAK)
      set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
    else()
      set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
    endif()
    message("${EppsteinWangAlgorithm_ENABLE_HARDENING} ${ENABLE_UBSAN_MINIMAL_RUNTIME} ${EppsteinWangAlgorithm_ENABLE_SANITIZER_UNDEFINED}")
    EppsteinWangAlgorithm_enable_hardening(EppsteinWangAlgorithm_options ON ${ENABLE_UBSAN_MINIMAL_RUNTIME})
  endif()
endmacro()

macro(EppsteinWangAlgorithm_local_options)
  if(PROJECT_IS_TOP_LEVEL)
    include(cmake/StandardProjectSettings.cmake)
  endif()

  add_library(EppsteinWangAlgorithm_warnings INTERFACE)
  add_library(EppsteinWangAlgorithm_options INTERFACE)

  include(cmake/CompilerWarnings.cmake)
  EppsteinWangAlgorithm_set_project_warnings(
    EppsteinWangAlgorithm_warnings
    ${EppsteinWangAlgorithm_WARNINGS_AS_ERRORS}
    ""
    ""
    ""
    "")

  if(EppsteinWangAlgorithm_ENABLE_USER_LINKER)
    include(cmake/Linker.cmake)
    configure_linker(EppsteinWangAlgorithm_options)
  endif()

  include(cmake/Sanitizers.cmake)
  EppsteinWangAlgorithm_enable_sanitizers(
    EppsteinWangAlgorithm_options
    ${EppsteinWangAlgorithm_ENABLE_SANITIZER_ADDRESS}
    ${EppsteinWangAlgorithm_ENABLE_SANITIZER_LEAK}
    ${EppsteinWangAlgorithm_ENABLE_SANITIZER_UNDEFINED}
    ${EppsteinWangAlgorithm_ENABLE_SANITIZER_THREAD}
    ${EppsteinWangAlgorithm_ENABLE_SANITIZER_MEMORY})

  set_target_properties(EppsteinWangAlgorithm_options PROPERTIES UNITY_BUILD ${EppsteinWangAlgorithm_ENABLE_UNITY_BUILD})

  if(EppsteinWangAlgorithm_ENABLE_PCH)
    target_precompile_headers(
      EppsteinWangAlgorithm_options
      INTERFACE
      <vector>
      <string>
      <utility>)
  endif()

  if(EppsteinWangAlgorithm_ENABLE_CACHE)
    include(cmake/Cache.cmake)
    EppsteinWangAlgorithm_enable_cache()
  endif()

  include(cmake/StaticAnalyzers.cmake)
  if(EppsteinWangAlgorithm_ENABLE_CLANG_TIDY)
    EppsteinWangAlgorithm_enable_clang_tidy(EppsteinWangAlgorithm_options ${EppsteinWangAlgorithm_WARNINGS_AS_ERRORS})
  endif()

  if(EppsteinWangAlgorithm_ENABLE_CPPCHECK)
    EppsteinWangAlgorithm_enable_cppcheck(${EppsteinWangAlgorithm_WARNINGS_AS_ERRORS} "" # override cppcheck options
    )
  endif()

  if(EppsteinWangAlgorithm_ENABLE_COVERAGE)
    include(cmake/Tests.cmake)
    EppsteinWangAlgorithm_enable_coverage(EppsteinWangAlgorithm_options)
  endif()

  if(EppsteinWangAlgorithm_WARNINGS_AS_ERRORS)
    check_cxx_compiler_flag("-Wl,--fatal-warnings" LINKER_FATAL_WARNINGS)
    if(LINKER_FATAL_WARNINGS)
      # This is not working consistently, so disabling for now
      # target_link_options(EppsteinWangAlgorithm_options INTERFACE -Wl,--fatal-warnings)
    endif()
  endif()

  if(EppsteinWangAlgorithm_ENABLE_HARDENING AND NOT EppsteinWangAlgorithm_ENABLE_GLOBAL_HARDENING)
    include(cmake/Hardening.cmake)
    if(NOT SUPPORTS_UBSAN 
       OR EppsteinWangAlgorithm_ENABLE_SANITIZER_UNDEFINED
       OR EppsteinWangAlgorithm_ENABLE_SANITIZER_ADDRESS
       OR EppsteinWangAlgorithm_ENABLE_SANITIZER_THREAD
       OR EppsteinWangAlgorithm_ENABLE_SANITIZER_LEAK)
      set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
    else()
      set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
    endif()
    EppsteinWangAlgorithm_enable_hardening(EppsteinWangAlgorithm_options OFF ${ENABLE_UBSAN_MINIMAL_RUNTIME})
  endif()

endmacro()
