################################################################################
cmake_minimum_required (VERSION 3.13)
################################################################################

################################################################################
# CMake version
################################################################################

message ("CMake version: " ${CMAKE_VERSION})

################################################################################

################################################################################
# Project name
################################################################################

project (SSHTools)

################################################################################

################################################################################
# Project properties
################################################################################

# find_package () modules location
list (APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/__cmake/Modules")

################################################################################

################################################################################

add_subdirectory ("Sources/Common")
add_subdirectory ("Sources/SSHCopy")

################################################################################
