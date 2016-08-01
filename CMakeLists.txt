cmake_minimum_required(VERSION 3.2 FATAL_ERROR)

enable_testing()

project(vigra_threadpool VERSION 0.1 LANGUAGES C CXX)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/vigra_cmake")
include(VigraAddExternal)
include(FindThreads)

vigra_add_external(vigra_core REPO https://github.com/vigralibs/vigra_core)

add_library(vigra_threadpool INTERFACE)
target_link_libraries(vigra_threadpool INTERFACE vigra_core Threads::Threads)

target_include_directories(vigra_threadpool INTERFACE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>)

install(DIRECTORY include/ DESTINATION include)
add_subdirectory(test)
