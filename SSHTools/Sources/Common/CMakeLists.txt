################################################################################
cmake_minimum_required (VERSION 3.13)
################################################################################

################################################################################
# Project name
################################################################################

project ("SSHTools_Common")

################################################################################

################################################################################
# Build/Configuration types
################################################################################

# Check for allowed build/configuration types
if (CMAKE_BUILD_TYPE)
  # Specifies the build type on single-configuration generators.
  if (NOT (("Debug" STREQUAL "${CMAKE_BUILD_TYPE}")
    OR ("Release" STREQUAL "${CMAKE_BUILD_TYPE}")
    OR ("RelWithDebInfo" STREQUAL "${CMAKE_BUILD_TYPE}"))
  )
    message (FATAL_ERROR
      "Unsupported build type: ${CMAKE_BUILD_TYPE}"
    )
  endif ()
endif ()

if (CMAKE_CONFIGURATION_TYPES)
  # Specifies the available build types on multi-config generators.
  if (NOT (("Debug" STREQUAL "${CMAKE_CONFIGURATION_TYPES}")
    OR ("Release" STREQUAL "${CMAKE_CONFIGURATION_TYPES}")
    OR ("RelWithDebInfo" STREQUAL "${CMAKE_CONFIGURATION_TYPES}"))
  )
    message (FATAL_ERROR
      "Unsupported configuration type: ${CMAKE_CONFIGURATION_TYPES}"
    )
  endif ()
endif ()

if (NOT (CMAKE_BUILD_TYPE OR CMAKE_CONFIGURATION_TYPES))
  message (FATAL_ERROR
    "No build or configuration type is set!"
  )
endif ()

################################################################################

################################################################################
# Target: ${PROJECT_NAME}_Base
################################################################################

include ("Common_Base.cmake")

################################################################################
