################################################################################
cmake_minimum_required (VERSION 3.13)
################################################################################

################################################################################
# Target: ${PROJECT_NAME}_ConfiParse
################################################################################

include ("ConfiParse_SourceFiles.cmake")
add_library (${PROJECT_NAME}_ConfiParse STATIC
  ${__ConfiParse_SourceFiles}
)

target_include_directories (${PROJECT_NAME}_ConfiParse
  PUBLIC
    "${CMAKE_CURRENT_LIST_DIR}/Include"
)

target_link_libraries (${PROJECT_NAME}_ConfiParse
  PRIVATE
    ${PROJECT_NAME}_Base
)

################################################################################
