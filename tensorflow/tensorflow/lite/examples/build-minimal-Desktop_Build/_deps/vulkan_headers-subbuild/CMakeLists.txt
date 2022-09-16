# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.16.0)

# We name the project and the target for the ExternalProject_Add() call
# to something that will highlight to the user what we are working on if
# something goes wrong and an error message is produced.

project(vulkan_headers-populate NONE)

include(ExternalProject)
ExternalProject_Add(vulkan_headers-populate
                     "UPDATE_DISCONNECTED" "False" "GIT_REPOSITORY" "https://github.com/KhronosGroup/Vulkan-Headers" "GIT_TAG" "ec2db85225ab410bc6829251bef6c578aaed5868" "GIT_PROGRESS" "TRUE" "PREFIX" "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build"
                    SOURCE_DIR          "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/vulkan_headers"
                    BINARY_DIR          "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/vulkan_headers-build"
                    CONFIGURE_COMMAND   ""
                    BUILD_COMMAND       ""
                    INSTALL_COMMAND     ""
                    TEST_COMMAND        ""
                    USES_TERMINAL_DOWNLOAD  YES
                    USES_TERMINAL_UPDATE    YES
)
