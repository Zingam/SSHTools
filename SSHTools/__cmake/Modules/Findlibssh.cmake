################################################################################
# Module: Findlibssh
################################################################################
# Defines:
#   * Imported targets:
#       REngine::libssh
#   * Variables:
#       libssh_FOUND          - If false, do not try to link to libssh
#       libssh_LIBRARY        - The name of the library to link against
#       libssh_INCLUDE_DIR    - The location of libssh header files
#       libssh_SHARED_LIBRARY - The name of the shared library (if available)
################################################################################
# Search paths:
#   * Environment variables (only one must be defined):
#       VCPKG_ROOT
#       __EXTERNAL_LIBS
#   * System paths
################################################################################

if (NOT (CMAKE_SIZEOF_VOID_P EQUAL 8))
  # If compile target is not 64bit
  message (FATAL_ERROR "(SSHTools) ==>  Only 64 bit targets are supported...")
endif ()

if (DEFINED ENV{VCPKG_ROOT})
  set (__SearchPath "$ENV{VCPKG_ROOT}/installed")

  if (WIN32)
    string (APPEND __SearchPath "/x64-windows")
  elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
    string (APPEND __SearchPath "/x64-linux")
  else ()
    message (FATAL_ERROR "(SSHTools) ==>  Unsupported target platform: ${CMAKE_SYSTEM}")
  endif ()

  set (__SearchPath_Library ${__SearchPath})

  if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    string (APPEND __SearchPath_Library "/debug")
  endif ()
endif ()

find_path (libssh_INCLUDE_DIR
  NAMES
    "libssh/libssh.h"
  HINTS
    ${__SearchPath}
  PATH_SUFFIXES
    "include"
)

find_library (libssh_LIBRARY
  NAMES
    "ssh"
  HINTS
    ${__SearchPath_Library}
  PATH_SUFFIXES
    "lib"
)

if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
  list (APPEND __LibraryFiles "ssh.dll")
  # Additional, linked shared libraries
  if (DEFINED ENV{VCPKG_ROOT})
    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
      set (__DebugSuffix "d")
    endif ()
    list (APPEND __LibraryFiles "zlib${__DebugSuffix}1.dll")
  endif ()

  set (__Number "0")

  foreach (__LibraryFile ${__LibraryFiles})
    # Increment library number
    math (EXPR __Number "${__Number} + 1")
    find_file (libssh_SHARED_LIBRARY_${__Number}
      NAMES
        ${__LibraryFile}
      HINTS
        ${__SearchPath_Library}
      PATH_SUFFIXES
        "bin"
      NO_DEFAULT_PATH
    )

    # Hide internal implementation details from user
    set_property (CACHE libssh_SHARED_LIBRARY_${__Number} PROPERTY TYPE INTERNAL)
    if (NOT libssh_SHARED_LIBRARY_${__Number})
      message (FATAL_ERROR "Unable to find library file: \"${__LibraryFile}\"")
    endif ()

    list (APPEND __libssh_SHARED_LIBRARY_TEMP ${libssh_SHARED_LIBRARY_${__Number}})
  endforeach()

  # Hide internal implementation details from user
  set (libssh_SHARED_LIBRARY ${__libssh_SHARED_LIBRARY_TEMP} CACHE INTERNAL "")

  unset (__libssh_SHARED_LIBRARY_TEMP)
  unset (__Number)
  unset (__LibraryFiles)
endif ()

unset (__SearchPath_Library)
unset (__SearchPath)

################################################################################
# find_package arguments
################################################################################

list (APPEND .PackageVariables
  libssh_INCLUDE_DIR
)
if (NOT ANDROID)
  list (APPEND .PackageVariables
    ${.PackageVariables}
    libssh_LIBRARY
  )
  if (libssh_SHARED_LIBRARY)
    list (APPEND .PackageVariables
      libssh_SHARED_LIBRARY
    )
  endif ()
endif ()

include (FindPackageHandleStandardArgs)
find_package_handle_standard_args (libssh
  REQUIRED_VARS
    ${.PackageVariables}
)

mark_as_advanced (${.PackageVariables})

unset (.PackageVariables)

################################################################################
# Imported target
################################################################################

if (libssh_FOUND AND NOT TARGET REngine::libssh)
  if (ANDROID) 
    add_library (REngine::libssh INTERFACE IMPORTED)
    set_property (TARGET REngine::libssh
      PROPERTY
        INTERFACE_INCLUDE_DIRECTORIES
          ${libssh_INCLUDE_DIR}
    )
    target_link_libraries(REngine::libssh
      INTERFACE
        libssh
    )
  else ()
    add_library (REngine::libssh UNKNOWN IMPORTED)
    set_target_properties (REngine::libssh
      PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES
          ${libssh_INCLUDE_DIR}
        IMPORTED_LOCATION
          ${libssh_LIBRARY}
    )
  endif ()
endif ()

################################################################################
