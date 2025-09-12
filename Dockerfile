# -----------------------------------------------------------
# Jetson Orin Nano 用 L4T r36.2.0 + 開発環境 + ROS2 Humble + GStreamer
# -----------------------------------------------------------

FROM nvcr.io/nvidia/l4t-base:r36.2.0

# -----------------------------------------------------------
# 非対話型設定（tzdata）
# -----------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

# -----------------------------------------------------------
# 基本ツール・Python・OpenCV のインストール
# -----------------------------------------------------------
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    python3 \
    python3-pip \
    curl \
    gnupg2 \
    lsb-release \
    locales \
    wget \
    libopencv-dev \
    libglib2.0-0 \
    libgstreamer1.0-dev \
    gstreamer1.0-tools \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    v4l-utils \
    && rm -rf /var/lib/apt/lists/*

# ロケール設定
RUN locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# -----------------------------------------------------------
# ROS 2 Humble のセットアップ
# -----------------------------------------------------------

# ROS 2 のキー追加とリポジトリ設定
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - \
    && sh -c 'echo "deb [arch=arm64] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'

# ROS 2 Humble Desktop のインストール
RUN apt-get update && apt-get install -y \
    ros-humble-ros-base \
    ros-dev-tools \
    python3-colcon-common-extensions \
    python3-argcomplete \
    && rm -rf /var/lib/apt/lists/*

# ROS 2 環境設定
SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
ENV ROS_DISTRO humble
ENV ROS_VERSION 2

# -----------------------------------------------------------
# Python 開発パッケージ
# -----------------------------------------------------------
RUN python3 -m pip install --no-cache-dir \
    numpy \
    matplotlib \
    opencv-python \
    jupyter \
    pyyaml

# -----------------------------------------------------------
# 環境変数（必要に応じて CUDA / cuDNN パスも追加可能）
# -----------------------------------------------------------
ENV PATH=/usr/local/cuda/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
