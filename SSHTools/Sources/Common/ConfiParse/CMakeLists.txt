################################################################################
cmake_minimum_required (VERSION 3.13)
################################################################################

################################################################################
# Project name
################################################################################

project ("ConfiParse")

################################################################################

include ("ConfiParse_SourceFiles.cmake")
add_library (${PROJECT_NAME} STATIC
  ${__ConfiParse_SourceFiles}
)

target_include_directories (${PROJECT_NAME}
  PUBLIC
    "./Include"
)

target_link_libraries (${PROJECT_NAME}
  PRIVATE
    Common_Base
)

################################################################################
