# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(agent_dart_library VERSION 0.0.1 LANGUAGES C)

add_library(agent_dart SHARED
  "agent_dart.c"
)

set_target_properties(agent_dart PROPERTIES
  PUBLIC_HEADER agent_dart.h
  OUTPUT_NAME "agent_dart"
)

target_compile_definitions(agent_dart PUBLIC DART_SHARED_LIB)
