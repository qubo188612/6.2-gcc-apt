FROM ubuntu:20.04 AS deploy
MAINTAINER State Of The Art <docker@state-of-the-art.io> (@stateoftheartio)

# PIP requirement like "aqtinstall==2.0.5" or url with egg file
ARG AQT_VERSION="aqtinstall==2.0.5"

ARG QT_VERSION=6.2.4
ARG QT_PATH=/opt/Qt

ARG ADDITIONAL_PACKAGES="sudo git openssh-client ca-certificates build-essential curl python3 locales patchelf"

USER root

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    QT_PATH=${QT_PATH} \
    QT_GCC=${QT_PATH}/${QT_VERSION}/gcc_64 \
    PATH=${QT_PATH}/Tools/CMake/bin:${QT_PATH}/Tools/Ninja:${QT_PATH}/${QT_VERSION}/gcc_64/bin:$PATH

COPY get_qt.sh get_linuxdeploy.sh install_packages.sh	/tmp/


# Get Qt binaries with aqt
RUN chmod 777 /tmp/get_qt.sh
RUN /tmp/get_qt.sh

# Get linuxdeploy and build it
RUN chmod 777 /tmp/get_linuxdeploy.sh 
RUN /tmp/get_linuxdeploy.sh

# Install the required packages
RUN chmod 777 /tmp/install_packages.sh
RUN /tmp/install_packages.sh

# Reconfigure locale
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# Add group & user + sudo
RUN groupadd -r user && useradd --create-home --gid user user && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

USER user
WORKDIR /home/user
ENV HOME /home/user
