
FROM nvidia/cudagl:11.1.1-base-ubuntu20.04

# Minimal setup

RUN apt-get update && apt-get -y install --no-install-recommends \
    python3 \
    python3-pip

RUN apt-get update\
    && apt-get -y install --no-install-recommends \
    wget \
    g++ \
    lsb-release\
    locales

RUN dpkg-reconfigure locales
ARG DEBIAN_FRONTEND=noninteractive
#
# Install ROS Noetic
#
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt-get update && apt-get install -y --no-install-recommends ros-noetic-desktop-full
RUN bash /opt/ros/noetic/setup.bash
RUN apt-get install -y --no-install-recommends python3-rosdep
    
RUN rosdep init \
 && rosdep fix-permissions \
 && rosdep update

#ros dependencies
RUN apt-get update && apt-get install -y\
    ros-noetic-tf2-geometry-msgs \
    python3-catkin-tools \
    ros-noetic-tf2-geometry-msgs \
    ros-noetic-catkin-virtualenv \
    ros-noetic-ros-control \
    ros-noetic-ros-controllers \
    ros-noetic-rosparam-shortcuts \
    ros-noetic-image-geometry \
    python3-catkin-tools 

#pip installations
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

#setup env variables for display
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV DISPLAY=:0
ENV QT_X11_NO_MITSHM=1

# Install ZSH
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.3/zsh-in-docker.sh)" -- \
    -t robbyrussell \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions
# Handy commands

# Handy commands
RUN echo 'export PATH="'"/home/$(id -un)/.local/bin"':$PATH''"' >> ~/.zshrc && \
    echo "alias limo=\"cd /home/thesis/ROS/\"" >> ~/.zshrc && \
    echo "alias cbuild='catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release'" >> ~/.zshrc && \ 
    echo "source /opt/ros/noetic/setup.zsh" >> ~/.zshrc  &&\
    echo "source /home/thesis/ROS/devel/setup.zsh" >> ~/.zshrc 

#add folder structure
WORKDIR /home/thesis
RUN mkdir Limo

CMD /bin/zsh