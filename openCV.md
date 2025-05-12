# rasbperrypi 3b+
## install openCV Full
sudo apt-get install build-essential cmake -y

sudo apt-get install libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev -y 

sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libxvidcore-dev libx264-dev libxine2-dev -y

sudo apt-get install libv4l-dev v4l-utils -y

sudo apt-get install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev -y

sudo apt-get install libgtk2.0-dev -y

sudo apt-get install mesa-utils libgl1-mesa-dri libgtkgl2.0-dev libgtkglext1-dev -y

sudo apt-get install libatlas-base-dev gfortran libeigen3-dev -y

## build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
        -D ENABLE_NEON=ON \
        -D WITH_FFMPEG=ON \
        -D WITH_TBB=ON \
        -D BUILD_TBB=ON \
        -D BUILD_TESTS=OFF \
        -D WITH_EIGEN=OFF \
        -D WITH_GSTREAMER=OFF \
        -D WITH_V4L=ON \
        -D WITH_LIBV4L=ON \
        -D WITH_VTK=OFF \
        -D WITH_QT=OFF \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D INSTALL_C_EXAMPLES=OFF \
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        -D BUILD_NEW_PYTHON_SUPPORT=ON \
        -D BUILD_opencv_python3=TRUE \
        -D OPENCV_GENERATE_PKGCONFIG=ON \
        -D BUILD_EXAMPLES=OFF ..

## Swap 

# rasbperrypi 5 
## install openCV Full
## Swap 


```
  # enlarge the boundary (CONF_MAXSWAP)
$ sudo vim /sbin/dphys-swapfile   CONF_MAXSWAP = 2048  -> CONF_MAXSWAP = 4096
  # give the required memory size (CONF_SWAPSIZE)
$ sudo vim /etc/dphys-swapfile   CONF_SWAPSIZE = 200 -> CONF_SWAPSIZE = 4096
$ sudo reboot
```
```
$ free -m
               총계    
메모리:         4041       
스  왑:         4095          
```
## OpenCV 4.10.0
```
wget https://github.com/Qengineering/Install-OpenCV-Raspberry-Pi-64-bits/raw/main/OpenCV-4-10-0.sh
sudo chmod 755 ./OpenCV-4-10-0.sh
./OpenCV-4-10-0.sh
```
```
# check for updates
$ sudo apt-get update
$ sudo apt-get upgrade
# dependencies
sudo apt-get install build-essential cmake git unzip pkg-config
sudo apt-get install libjpeg-dev libpng-dev
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install libgtk2.0-dev libcanberra-gtk* libgtk-3-dev
sudo apt-get install libgstreamer1.0-dev gstreamer1.0-gtk3
sudo apt-get install libgstreamer-plugins-base1.0-dev gstreamer1.0-gl
sudo apt-get install libxvidcore-dev libx264-dev
sudo apt-get install python3-dev python3-numpy python3-pip
sudo apt-get install libtbbmalloc2 libtbb-dev
sudo apt-get install libv4l-dev v4l-utils
sudo apt-get install libopenblas-dev libatlas-base-dev libblas-dev
sudo apt-get install liblapack-dev gfortran libhdf5-dev
sudo apt-get install libprotobuf-dev libgoogle-glog-dev libgflags-dev
sudo apt-get install protobuf-compiler
```
## Cleaning
```
$ sudo vim /sbin/dphys-swapfile
# set CONF_MAXSWAP=2048 with the vim text editor
$ sudo nano /etc/dphys-swapfile
# set CONF_SWAPSIZE=200 with the vim text editor
$ sudo reboot
```
