# syntax=docker/dockerfile:1
FROM ubuntu:22.04 AS builder

# Make a working directory
WORKDIR /ardupilot

################################################################################
### Install minimal build tools and remove cache. Don't do any update

RUN apt-get update && apt-get install --no-install-recommends -y \
    g++ \
    git \
    python3-pip \
    python-is-python3 \
    libxml2-dev \
    libxslt-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN python3 -m pip install --user --no-deps --no-cache-dir future empy pexpect ptyprocess

# Clone simplified. Don't clone all the tree and nuttx stuff
# put pymavlink to latest to work with python3 and recent gcc
RUN git clone https://github.com/ardupilot/ardupilot.git --depth 1 --no-single-branch src \
    && cd src \
    && git submodule update --init --recursive --depth 1 modules/mavlink \
    && git submodule update --init --recursive --depth 1 modules/uavcan \
    && git submodule update --init --recursive --depth 1 modules/DroneCAN \
    && git submodule update --init --recursive --depth 1 modules/waf


# Build binary
RUN cd /ardupilot/src && ./waf configure --board sitl --no-submodule-update \
    && ./waf copter

# Second stage build
FROM ubuntu:22.04

WORKDIR /ardupilot

# copy only the dependencies installation from the 1st stage image


# Copy binary and defaut param file from previous image
COPY --from=builder /ardupilot/src/build/sitl/bin/arducopter .
COPY --from=builder /ardupilot/src/Tools/autotest/default_params/copter.parm .

COPY sitl_launch.bash /bin/sitl_launch.bash
# SITL 1
EXPOSE 5760/tcp
EXPOSE 5762/tcp
EXPOSE 5763/tcp
EXPOSE 5501
# SITL 2
EXPOSE 5770/tcp
EXPOSE 5772/tcp
EXPOSE 5773/tcp
EXPOSE 5511
# SITL 3
EXPOSE 5780/tcp
EXPOSE 5782/tcp
EXPOSE 5783/tcp
EXPOSE 5521

# Multicast
EXPOSE 14550/tcp
EXPOSE 14550/udp

ENTRYPOINT ["sitl_launch.bash"]
CMD ["bash"]
