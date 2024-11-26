# 1. 시스템 업데이트 및 필수 패키지 설치
```
sudo apt update
sudo apt upgrade
sudo apt install build-essential cmake git pkg-config
sudo apt install libjpeg-dev libtiff-dev libpng-dev
sudo apt install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt install libxvidcore-dev libx264-dev
sudo apt install libgtk-3-dev
sudo apt install libatlas-base-dev gfortran
sudo apt install python3-dev
```
# 2. OpenCV 및 OpenCV Contrib 소스코드 다운로드
```
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git
```
# 3. OpenCV 빌드 디렉토리 생성
```
cd ~/opencv
mkdir build
cd build
```
# 4. CMake를 사용하여 OpenCV 설정
```
cmake -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
      -D BUILD_EXAMPLES=ON ..
```
# 5. OpenCV 컴파일 및 설치
```
make -j4
sudo make install
sudo ldconfig
```
