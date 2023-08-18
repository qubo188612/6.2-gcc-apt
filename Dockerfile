ARG ROS_DISTRO

# Compile OpenCV
FROM ros:${ROS_DISTRO} AS base

# Install wget
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    mesa-common-dev \
    build-essential \
    doxygen \
    wget \
    unzip 

RUN wget https://download.qt.io/archive/qt/5.12/5.12.8/single/qt-everywhere-src-5.12.8.tar.xz && \
    tar -xf qt-everywhere-src-5.12.8.tar.xz && \
    cd qt-everywhere-src-5.12.8 && \
    ./configure && \
    make -j8 && \
    make install DESTDIR= /opt/Qt

RUN rm -f qt-everywhere-src-5.12.8.tar.xz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use busybox as package container
FROM busybox:latest

# Copy from base to busybox
COPY --from=base /opt/Qt /setup/opt/Qt

