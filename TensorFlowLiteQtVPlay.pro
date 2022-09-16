QT += quick
QT += widgets sql
QT += qml quick
QT += gui
QT += core
QT += network
QT += xml
QT += svg
QT += multimedia
QT += core-private
QT += multimedia
QT += opengl
QT += concurrent
QT += quickwidgets
QT += multimediawidgets
QT += multimedia-private

# uncomment this line to add the Live Client Module and use live reloading with your custom C++ code
# for the remaining steps to build a custom Live Code Reload app see here: https://v-play.net/custom-code-reload-app/
#CONFIG += v-play-live

# configure the bundle identifier for iOS
PRODUCT_IDENTIFIER = com.dk.TfliteDemo.ObjectDetection

qmlFolder.source = qml

assetsFolder.source = assets
DEPLOYMENTFOLDERS += assetsFolder

# NOTE: for PUBLISHING, perform the following steps:
# 1. comment the DEPLOYMENTFOLDERS += qmlFolder line above, to avoid shipping your qml files with the application (instead they get compiled to the app binary)
# 2. uncomment the resources.qrc file inclusion and add any qml subfolders to the .qrc file; this compiles your qml files and js files to the app binary and protects your source code
# 3. change the setMainQmlFile() call in main.cpp to the one starting with "qrc:/" - this loads the qml files from the resources
# for more details see the "Deployment Guides" in the V-Play Documentation

# during development, use the qmlFolder deployment because you then get shorter compilation times (the qml files do not need to be compiled to the binary but are just copied)
# also, for quickest deployment on Desktop disable the "Shadow Build" option in Projects/Builds - you can then select "Run Without Deployment" from the Build menu in Qt Creator if you only changed QML files; this speeds up application start, because your app is not copied & re-compiled but just re-interpreted

# Debug or release mode

!win32 {
# This works for Linux and macOS, appropiate copy command must be set for Windows
CONFIG(debug,debug|release):system($$quote(cp "$$PWD/qml/config_debug.json" "$$PWD/qml/config.json"))
CONFIG(release,debug|release):system($$quote(cp "$$PWD/qml/config_release.json" "$$PWD/qml/config.json"))

CONFIG(debug,debug|release):DEPLOYMENTFOLDERS += qmlFolder # comment for publishing
CONFIG(release,debug|release):RESOURCES += resources.qrc # uncomment for publishing

CONFIG(release,debug|release):CONFIG += qtquickcompiler # Qt Quick compiler
}

QT += multimedia multimedia-private

RESOURCES += resources.qrc

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    ConstGlobal.cpp \
    objectsrecogfilter.cpp \
    tensorflow/tensorflow/build-lite-Desktop_Qt_5_14_1_MinGW_64_bit-Debug/ruy/ruy/block_map.cc \
    tensorflow/tensorflow/build-lite-Desktop_Qt_5_14_1_MinGW_64_bit-Debug/ruy/ruy/blocking_counter.cc \
    tensorflow/tensorflow/build-lite-Desktop_Qt_5_14_1_MinGW_64_bit-Debug/ruy/ruy/thread_pool.cc \
    tensorflowthread.cpp \
    auxutils.cpp \
    colormanager.cpp \
    tensorflowlite.cpp

INCLUDEPATH += $$PWD/include \
               $$PWD/include/tensorflow



android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    OTHER_FILES += android/AndroidManifest.xml \
                   android/build.gradle
}

ios {
    QMAKE_INFO_PLIST = ios/Project-Info.plist
    OTHER_FILES += $$QMAKE_INFO_PLIST
}

# set application icons for win and macx
win32 {
    PKGCONFIG += openssl
    QMAKE_CXXFLAGS_WARN_OFF -= -Wunused-parameter
    DEFINES += QT_DEPRECATED_WARNINGS
    DEFINES += __Win__

    MSVC_PATH  = "C:/Qt/Qt5.14.1/5.14.1/mingw73_64"
    TENSORFLOW_PATH = $$PWD/tensorflow
    QTPLUGIN += /plugins

    QMAKE_LFLAGS += -Wl,--rpath=\$$ORIGIN/lib

    LIBS += -L$$MSVC_PATH/lib -lpthread



    INCLUDEPATH+=$$MSVC_PATH/include \
                 $$TENSORFLOW_PATH \
                 $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/flatbuffers/include \
                 $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/fft2d


    RC_FILE += win/app_icon.rc


    win32: LIBS += -L$$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/tensorflow-lite -ltensorflow-lite

    INCLUDEPATH += $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build
    DEPENDPATH += $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build

}
macx {
    ICON = macx/app_icon.icns
}

# TensorFlow Lite - Global

# TensorFlow Lite - Linux
linux:!android {
    TENSORFLOW_PATH = $$PWD/lib/tfLibs/linux
    LIBS += -L$$TENSORFLOW_PATH/tensorflow/lite -ltensorflowlite \
             -ldl
}

# TensorFlow Lite - Android - armv7a
android {
    TENSORFLOW_PATH = $$PWD/lib/tfLibs/ardroid/tfLibs
    DEFINES += __android__
    #    QT      += androidextras
    #    CONFIG  += declarative_debug
    CONFIG  += qml_debug
    CONFIG  += console

    CONFIG += AndroidBuild MobileBuild

    QT += androidextras
    LIBS += -L$$TENSORFLOW_PATH/tensorflow/lite \
            -L$$TENSORFLOW_PATH/tensorflow/lite/c \
            -L$$TENSORFLOW_PATH/tensorflow/lite/core/api \
            -L$$TENSORFLOW_PATH/tensorflow/lite/kernels \
            -L$$TENSORFLOW_PATH/tensorflow/lite/kernels/internal \
            -L$$TENSORFLOW_PATH/external/farmhash_archive \
            -L$$TENSORFLOW_PATH/external/fft2d \
            -L$$TENSORFLOW_PATH/external/flatbuffers/src \
            -L$$TENSORFLOW_PATH/external/XNNPACK \
            -lflatbuffers.pic -lapi.pic -lbuiltin_op_kernels.pic -lkernel_util.pic \
            -leigen_support.pic -laudio_utils.pic -lkernel_utils.pic -ltensor_utils.pic \
            -lneon_tensor_utils.pic -lquantization_util.pic -llstm_eval.pic -lfarmhash.pic \
            -lfft2d.pic -lallocation.pic -larena_planner.pic -lexternal_cpu_backend_context.pic -lgraph_info.pic \
            -lminimal_logging.pic -lmodel_builder.pic -lmutable_op_resolver.pic -loptional_debug_tools.pic \
            -lsimple_memory_arena.pic -lstderr_reporter.pic -lstring_util.pic -ltensorflowlite \
            -ltflite_with_xnnpack_optional.pic -lutil.pic -lxnnpack_for_tflite.pic -leigen_support.pic

            ANDROID_EXTRA_LIBS = $$TENSORFLOW_PATH/tensorflow/lite/libtensorflowlite.so
}

# TensorFlow Lite - iOS - Universal library
ios {
        LIBS += -L$$TFLITE_MAKE_PATH/gen/lib/ \
                -framework Accelerate \
                -ltensorflow-lite
}

DISTFILES += \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml \
    qml/AppSettingsPage.qml \
    qml/Main.qml \
    qml/VideoPage.qml \
    AppSettingsPage.qml \
    qml/PopupMessage.qml

HEADERS += \
    ConstGlobal.h \
    objectsrecogfilter.h \
    $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/ruy/ruy/block_map.h \
    $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/ruy/ruy/blocking_counter.h \
    $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build//ruy/ruy/thread_pool.h \
    tensorflowthread.h \
    auxutils.h \
    colormanager.h \
    get_top_n_impl.h \
    get_top_n.h \
    tensorflowlite.h

LD_LIBRARY_PATH += $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build

#LIBS += -L$$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/ruy-build/ruy -lruy_allocator -lruy_apply_multiplier -lruy_block_map -lruy_context -lruy_context_get_ctx -lruy_cpuinfo -lruy_ctx -lruy_denormal -lruy_frontend -lruy_have_built_path_for_avx -lruy_have_built_path_for_avx2_fma -lruy_have_built_path_for_avx512 -lruy_kernel_arm -lruy_kernel_avx -lruy_kernel_avx2_fma -lruy_kernel_avx512 -lruy_pack_arm -lruy_pack_avx -lruy_pack_avx2_fma -lruy_pack_avx512 -lruy_prepacked_cache -lruy_prepare_packed_matrices -lruy_system_aligned_alloc -lruy_thread_pool -lruy_trmul -lruy_tune -lruy_wait
LIBS += -L$$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/ruy-build/ruy -lruy_allocator -lruy_apply_multiplier -lruy_block_map -lruy_context -lruy_context_get_ctx -lruy_cpuinfo -lruy_ctx -lruy_denormal -lruy_frontend -lruy_have_built_path_for_avx -lruy_have_built_path_for_avx2_fma -lruy_have_built_path_for_avx512 -lruy_kernel_arm -lruy_kernel_avx -lruy_kernel_avx2_fma -lruy_kernel_avx512 -lruy_pack_arm -lruy_pack_avx -lruy_pack_avx2_fma -lruy_pack_avx512 -lruy_prepacked_cache -lruy_prepare_packed_matrices -lruy_system_aligned_alloc -lruy_thread_pool -lruy_trmul -lruy_tune -lruy_wait
LIBS += -L$$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/ruy-build/ruy/profiler -lruy_profiler_instrumentation
LIBS += -L$$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/xnnpack-build -lXNNPACK
LIBS += -L$$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/cpuinfo-build -lcpuinfo
LIBS += -L$$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/clog-build -lclog
LIBS += -L$$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/fft2d-build -lfft2d_fftsg -lfft2d_fftsg2d
LIBS += -L$$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/pthreadpool -lpthreadpool
LIBS += -L$$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/farmhash-build -lfarmhash
LIBS += -L$$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/base -labsl_base

INCLUDEPATH += $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/base \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/container \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/debugging \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/flags \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/hash \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/numeric \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/profiling \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/status \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/strings \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/synchronization \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/time \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/types \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/clog-build \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/cpuinfo-build \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/farmhash-build \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/fft2d-build \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/flatbuffers-build \
#               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/ruy-build/ruy \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/build-ruy-Desktop_Qt_5_14_1_MinGW_64_bit-Debug/ruy \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/ruy \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/xnnpack-build

DEPENDPATH +=  $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/base \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/container \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/debugging \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/flags \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/hash \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/numeric \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/profiling \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/status \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/strings \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/synchronization \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/time \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/abseil-cpp-build/absl/types \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/clog-build \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/cpuinfo-build \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/farmhash-build \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/fft2d-build \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/flatbuffers-build \
#               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/ruy-build/ruy \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/build-ruy-Desktop_Qt_5_14_1_MinGW_64_bit-Debug/ruy \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/ruy \
               $$PWD/tensorflow/tensorflow/lite/examples/build-minimal-Desktop_Build/_deps/xnnpack-build
