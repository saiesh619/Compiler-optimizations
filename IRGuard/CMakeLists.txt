cmake_minimum_required(VERSION 3.20)

project(IRGuard LANGUAGES CXX)

find_package(LLVM REQUIRED CONFIG)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "LLVMConfig.cmake found at: ${LLVM_DIR}")

list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})

add_llvm_pass_plugin(IRGuardPass
    src/IRGuard.cpp
)

target_compile_features(IRGuardPass PRIVATE cxx_std_17)
