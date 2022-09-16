### Dependancy
- Tensoflow 
- Cmake
- Python
- Android SDK
- Make
- bazel
- QT

# Steps to setup
1. install Cmake latest version 

```bash
    sudo apt remove --purge --auto-remove cmake
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
    sudo apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
    sudo apt update
    sudo apt install kitware-archive-keyring
    sudo rm /etc/apt/trusted.gpg.d/kitware.gpg
    sudo apt update
    sudo apt install cmake
	cmake --version
```

2 . Install QT
	Download and install QT 5.14
3 . Install Android Stdio
SDK - 28
NDK - 21.3.6528147sudo apt install bazel-1.0.0
Build tools - 32.0.0

4 . Install bazel

```bash
sudo apt install apt-transport-https curl gnupg
curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor > bazel.gpg
sudo mv bazel.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
sudo apt update && sudo apt install bazel
sudo apt install bazel=5.0.0
sudo ln -s /usr/bin/bazel /usr/bin/bazel #or sudo ln -s /usr/bin/bazel-5.0.0 /usr/bin/bazel
bazel --version 
```

##Compile Tensorflow
1. For android :
```bash
./configure
**set Android options yes**
cd tensorflow
bazel build -c opt --config=android_arm64 --cpu=armeabi-v7a --define tflite_with_xnnpack=true //tensorflow/lite:tensorflowlite
```

2. For linux
```bash
mkdir tflite_build
cd tflite_build
cmake ../tensorflow/tensorflow/lite
cmake --build . -j8
```
###Libs Location 
-  android - > (Project Path )/lib/tfLibs/ardroid
-  linux - > (Project Path )/lib/tfLibs/linux

