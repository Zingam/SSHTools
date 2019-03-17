################################################################################
cmake_minimum_required (VERSION 3.13)
################################################################################

################################################################################
# Project name
################################################################################

project ("SSHCopy")

################################################################################

################################################################################
# Project settings
################################################################################

option (option_DeployQt5ToBinaryDirectory
  "Deploy Qt5 libraries to the executable output directory?"
  NO
)

################################################################################

################################################################################
# Target: ${PROJECT_NAME}
################################################################################

include (SSHCopy_SourceFiles.cmake)
add_executable (${PROJECT_NAME}
  # Platform resources (Windows)
  $<$<PLATFORM_ID:Windows>:Resources/Windows/DpiAwareness.manifest>
  $<$<AND:$<PLATFORM_ID:Windows>,$<CXX_COMPILER_ID:MSVC>>:Resources/Windows/SSHCopy.rc>
  # Source files
  ${__SSHCopy_SourceFiles}
)

if (WIN32)
  set_property (TARGET ${PROJECT_NAME}
    PROPERTY
      WIN32_EXECUTABLE NO
  )
endif ()

target_include_directories (${PROJECT_NAME}
  PRIVATE
    "Sources"
)

target_link_libraries (${PROJECT_NAME}
  PRIVATE
    SSHTools_Common_Base
)

################################################################################
# External libraries
################################################################################

find_package (libssh REQUIRED)
list (APPEND __SharedLibraries ${libssh_SHARED_LIBRARY})

target_link_libraries (${PROJECT_NAME}
  PRIVATE
    REngine::libssh
)

# Add Qt5 install location to search path
if (NOT DEFINED ENV{Qt5_ROOT})
  message (FATAL_ERROR
    "Environment variable Qt5_ROOT not found. Is Qt5 installed? "
  )
endif ()

cmake_policy (SET CMP0074 NEW)
list (APPEND CMAKE_PREFIX_PATH $ENV{Qt5_ROOT})

# Find includes in corresponding build directories
set (CMAKE_INCLUDE_CURRENT_DIR ON)
# Instruct CMake to run moc automatically when needed
set (CMAKE_AUTOMOC ON)
# Create code from a list of Qt designer ui files
set (CMAKE_AUTOUIC ON)

# Find the QtWidgets library
find_package (Qt5 COMPONENTS Widgets CONFIG REQUIRED)
target_link_libraries (${PROJECT_NAME}
  PRIVATE
    Qt5::Widgets
)

################################################################################

################################################################################
# Installation
################################################################################

message ("Shared libraries to install:")
foreach (__SharedLibrary ${__SharedLibraries})
  message ("    ${__SharedLibrary}")
endforeach ()

# Set installation path
set (InstallationPath ${CMAKE_INSTALL_PREFIX})

# Install targets
install (
  TARGETS
    ${PROJECT_NAME}
  RUNTIME DESTINATION
    ${InstallationPath}
)

# Installation required files
install (
  FILES
    ${__SharedLibraries}
  DESTINATION
    ${InstallationPath}
)

unset (__SharedLibraries)

# Windows specific installation steps
if (WIN32)
    # Run winddeployqt if it can be found
    find_program (__windeployqt_Executable
      NAMES
        "windeployqt"
      HINTS
        ${QTDIR}
        ENV QTDIR
      PATH_SUFFIXES
        "bin"
    )

    if (__windeployqt_Executable)
      message ("File found: ${__windeployqt_Executable}")
    else ()
      message (FATAL_ERROR "File not found: windeployqt")
    endif()

    if (option_DeployQt5ToBinaryDirectory)
      add_custom_command (
        TARGET
          ${PROJECT_NAME}
        POST_BUILD
          COMMAND
            "${__windeployqt_Executable}" "$<TARGET_FILE:${PROJECT_NAME}>"
      )
    endif ()

    # Get the target's output filepath
    file (GENERATE
      OUTPUT
        "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_Filepath"
      CONTENT
        "$<TARGET_FILE:${PROJECT_NAME}>"
    )

    install (
      CODE
      "
        # Get the executable file name
        file (READ \"${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_Filepath\"
          __Executable_Filepath
        )
        get_filename_component (__ExecutableName
          \"\${__Executable_Filepath}\"
          NAME
        )
        # Deploy the Qt5 runtime
        execute_process( 
          COMMAND 
            ${__windeployqt_Executable}
              --no-translations
              \"${InstallationPath}/\${__ExecutableName}\"
        )
      "
    )

    unset (__windeployqt_Executable)
endif()

################################################################################
