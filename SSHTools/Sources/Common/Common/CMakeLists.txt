################################################################################
cmake_minimum_required (VERSION 3.13)
################################################################################

################################################################################
# Target: ${PROJECT_NAME}_Common
################################################################################

include ("Common_SourceFiles.cmake")
add_library (${PROJECT_NAME}_Common STATIC
  ${__Common_SourceFiles}
)

target_include_directories (${PROJECT_NAME}_Common
  PUBLIC
    "${CMAKE_CURRENT_LIST_DIR}/Include"
)

target_link_libraries (${PROJECT_NAME}_Common
  PRIVATE
    ${PROJECT_NAME}_Base
)

################################################################################
