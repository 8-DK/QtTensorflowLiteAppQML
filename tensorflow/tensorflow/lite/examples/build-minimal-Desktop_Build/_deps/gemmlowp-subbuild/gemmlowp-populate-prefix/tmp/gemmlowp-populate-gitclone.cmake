
if(NOT "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/gemmlowp-subbuild/gemmlowp-populate-prefix/src/gemmlowp-populate-stamp/gemmlowp-populate-gitinfo.txt" IS_NEWER_THAN "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/gemmlowp-subbuild/gemmlowp-populate-prefix/src/gemmlowp-populate-stamp/gemmlowp-populate-gitclone-lastrun.txt")
  message(STATUS "Avoiding repeated git clone, stamp file is up to date: 'E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/gemmlowp-subbuild/gemmlowp-populate-prefix/src/gemmlowp-populate-stamp/gemmlowp-populate-gitclone-lastrun.txt'")
  return()
endif()

execute_process(
  COMMAND ${CMAKE_COMMAND} -E remove_directory "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/gemmlowp"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to remove directory: 'E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/gemmlowp'")
endif()

# try the clone 3 times in case there is an odd git clone issue
set(error_code 1)
set(number_of_tries 0)
while(error_code AND number_of_tries LESS 3)
  execute_process(
    COMMAND "C:/Program Files/Git/bin/git.exe"  clone --no-checkout --progress "https://github.com/google/gemmlowp" "gemmlowp"
    WORKING_DIRECTORY "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build"
    RESULT_VARIABLE error_code
    )
  math(EXPR number_of_tries "${number_of_tries} + 1")
endwhile()
if(number_of_tries GREATER 1)
  message(STATUS "Had to git clone more than once:
          ${number_of_tries} times.")
endif()
if(error_code)
  message(FATAL_ERROR "Failed to clone repository: 'https://github.com/google/gemmlowp'")
endif()

execute_process(
  COMMAND "C:/Program Files/Git/bin/git.exe"  checkout fda83bdc38b118cc6b56753bd540caa49e570745 --
  WORKING_DIRECTORY "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/gemmlowp"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to checkout tag: 'fda83bdc38b118cc6b56753bd540caa49e570745'")
endif()

set(init_submodules TRUE)
if(init_submodules)
  execute_process(
    COMMAND "C:/Program Files/Git/bin/git.exe"  submodule update --recursive --init 
    WORKING_DIRECTORY "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/gemmlowp"
    RESULT_VARIABLE error_code
    )
endif()
if(error_code)
  message(FATAL_ERROR "Failed to update submodules in: 'E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/gemmlowp'")
endif()

# Complete success, update the script-last-run stamp file:
#
execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/gemmlowp-subbuild/gemmlowp-populate-prefix/src/gemmlowp-populate-stamp/gemmlowp-populate-gitinfo.txt"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/gemmlowp-subbuild/gemmlowp-populate-prefix/src/gemmlowp-populate-stamp/gemmlowp-populate-gitclone-lastrun.txt"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to copy script-last-run stamp file: 'E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/gemmlowp-subbuild/gemmlowp-populate-prefix/src/gemmlowp-populate-stamp/gemmlowp-populate-gitclone-lastrun.txt'")
endif()

