# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.16.0)

# We name the project and the target for the ExternalProject_Add() call
# to something that will highlight to the user what we are working on if
# something goes wrong and an error message is produced.

project(opengl_headers-populate NONE)

include(ExternalProject)
ExternalProject_Add(opengl_headers-populate
                     "UPDATE_DISCONNECTED" "False" "GIT_REPOSITORY" "https://github.com/KhronosGroup/OpenGL-Registry.git" "GIT_TAG" "0cb0880d91581d34f96899c86fc1bf35627b4b81" "GIT_PROGRESS" "TRUE" "PREFIX" "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build"
                    SOURCE_DIR          "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/opengl_headers"
                    BINARY_DIR          "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/opengl_headers-build"
                    CONFIGURE_COMMAND   ""
                    BUILD_COMMAND       ""
                    INSTALL_COMMAND     ""
                    TEST_COMMAND        ""
                    USES_TERMINAL_DOWNLOAD  YES
                    USES_TERMINAL_UPDATE    YES
)
