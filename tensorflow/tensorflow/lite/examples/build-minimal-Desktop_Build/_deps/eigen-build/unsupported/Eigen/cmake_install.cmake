# Install script for directory: E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files (x86)/minimal")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "MinSizeRel")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xDevelx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/eigen3/unsupported/Eigen" TYPE FILE FILES
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/AdolcForward"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/AlignedVector3"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/ArpackSupport"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/AutoDiff"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/BVH"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/EulerAngles"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/FFT"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/IterativeSolvers"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/KroneckerProduct"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/LevenbergMarquardt"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/MatrixFunctions"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/MoreVectorization"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/MPRealSupport"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/NonLinearOptimization"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/NumericalDiff"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/OpenGLSupport"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/Polynomials"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/Skyline"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/SparseExtra"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/SpecialFunctions"
    "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/Splines"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xDevelx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/eigen3/unsupported/Eigen" TYPE DIRECTORY FILES "E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/eigen/unsupported/Eigen/src" FILES_MATCHING REGEX "/[^/]*\\.h$")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("E:/pdrl/GCSObjectDetection/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/eigen-build/unsupported/Eigen/CXX11/cmake_install.cmake")

endif()

