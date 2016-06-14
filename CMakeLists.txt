cmake_minimum_required(VERSION 3.2 FATAL_ERROR)

enable_testing()

project(threadpool VERSION 0.1 LANGUAGES CXX)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/vigralibs_cmake")
include(VigraAddExternal)
# This variable needs to be set before including FindThreads. Doing so, it will enable
# the "-pthread" flag (if using POSIX threads) to anything linking to the threadpool
# interface.
set(THREADS_PREFER_PTHREAD_FLAG YES)
include(FindThreads)

vigra_add_external(foundation REPO https://github.com/vigralibs/foundation)

add_library(threadpool INTERFACE)
target_link_libraries(threadpool INTERFACE foundation INTERFACE Threads::Threads)

target_include_directories(threadpool INTERFACE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>)

install(DIRECTORY include/ DESTINATION include)
add_subdirectory(test)
