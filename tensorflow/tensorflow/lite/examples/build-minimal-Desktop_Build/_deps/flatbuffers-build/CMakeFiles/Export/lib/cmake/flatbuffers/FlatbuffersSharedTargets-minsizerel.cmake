#----------------------------------------------------------------
# Generated CMake target import file for configuration "MinSizeRel".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "flatbuffers::flatbuffers_shared" for configuration "MinSizeRel"
set_property(TARGET flatbuffers::flatbuffers_shared APPEND PROPERTY IMPORTED_CONFIGURATIONS MINSIZEREL)
set_target_properties(flatbuffers::flatbuffers_shared PROPERTIES
  IMPORTED_IMPLIB_MINSIZEREL "${_IMPORT_PREFIX}/lib/libflatbuffers.dll.a"
  IMPORTED_LOCATION_MINSIZEREL "${_IMPORT_PREFIX}/lib/libflatbuffers.dll"
  )

list(APPEND _IMPORT_CHECK_TARGETS flatbuffers::flatbuffers_shared )
list(APPEND _IMPORT_CHECK_FILES_FOR_flatbuffers::flatbuffers_shared "${_IMPORT_PREFIX}/lib/libflatbuffers.dll.a" "${_IMPORT_PREFIX}/lib/libflatbuffers.dll" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
