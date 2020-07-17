cmake_minimum_required(VERSION 3.10)
include(CheckIncludeFileCXX)

# project name
project(logger)

# add option to build 64bit extensions; default to 32bit
option(Build64 "Whether to build the 64bit binaries instead of the 32bit ones" OFF)


#set include-directory
include_directories(${logger_SOURCE_DIR}/include)

add_library(logger SHARED src/Logger.cpp)

set_property(TARGET logger PROPERTY CXX_STANDARD 17)
set_property(TARGET logger PROPERTY CXX_STANDARD_REQUIRED ON)

# set public header for shared libraries
set_target_properties(logger PROPERTIES PUBLIC_HEADER include/DllEntry.hpp)

if(Build64)
    # set 64 bit names
    set_target_properties(logger PROPERTIES PREFIX "" OUTPUT_NAME "logger_x64")
else(Build64)
    # set 32bit names
    set_target_properties(logger PROPERTIES PREFIX "" OUTPUT_NAME "logger")
endif(Build64)


CHECK_INCLUDE_FILE_CXX("filesystem" FOUND_FILESYSTEM_HEADERS)
if(FOUND_FILESYSTEM_HEADERS)
	message("Found <filesystem> header file")
else()
	CHECK_INCLUDE_FILE_CXX("experimental/filesystem" FOUND_EXP_FILESYSTEM_HEADERS)
	if(NOT FOUND_EXP_FILESYSTEM_HEADERS)
		message(FATAL_ERROR "Unable to include <filesystem> or <experimental/filesystem>")
	else()
		message("Using <experimental/filesystem> headers")
		add_definitions(-DEXPERIMENTAL_FILESYSTEM)
	endif()
endif()


# Detect whether compilation is done on linux
if("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
    message("Detected Linux system - building linux binaries...")

    
    # specify architecture specific settings and linkings
    if(Build64)
        message("Building 64bit binaries")


        # set compiler flags
        set_target_properties(logger PROPERTIES COMPILE_FLAGS "-m64" LINK_FLAGS "-m64")
    else(Build64)
        message("Building 32bit binaries")


        # set compiler flags
        set_target_properties(logger PROPERTIES COMPILE_FLAGS "-m32" LINK_FLAGS "-m32")
    endif(Build64)
    
endif("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")


# Detect whether compilation is done on windows
if("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
    message("Detected Windows system - building Windows binaries...")


    # let preprocessor know about windows environment via the WINDOWS macro
    add_definitions(-DWINDOWS)


    # specify architecture specific settings and linkings
    if(Build64)
        message("Building 64bit binaries")
    else(Build64)
        message("Building 32bit binaries")
    endif(Build64)
    
    
    message(FATAL_ERROR "Build not yet implemented for Windows!")
endif("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
