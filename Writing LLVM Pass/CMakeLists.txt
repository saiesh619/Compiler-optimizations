cmake_minimum_required(VERSION 3.13)
project(OptimizationPasses)

find_package(LLVM REQUIRED CONFIG)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

# Your pass library
add_library(OptimizationPasses MODULE
    passes/DeadCodeElimination.cpp
    passes/ConstantPropagation.cpp
    passes/CSE.cpp
    passes/LoopInvariantCodeMotion.cpp
)

llvm_map_components_to_libnames(LLVM_LIBS
    core
    support
    passes
)

target_link_libraries(OptimizationPasses PRIVATE ${LLVM_LIBS})

set_target_properties(OptimizationPasses PROPERTIES
    COMPILE_FLAGS "-fno-rtti"
)

# NEW PART (for running your passes)
add_executable(run_passes run_passes.cpp)

target_include_directories(run_passes PRIVATE ${LLVM_INCLUDE_DIRS})
target_compile_definitions(run_passes PRIVATE ${LLVM_DEFINITIONS})

llvm_map_components_to_libnames(LLVM_RUN_LIBS
    core
    support
    passes
    irreader
)

target_link_libraries(run_passes PRIVATE ${LLVM_RUN_LIBS})