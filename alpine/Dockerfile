# syntax=docker/dockerfile:1
FROM alpine:3.16 AS builder

# Make a working directory
WORKDIR /ardupilot

################################################################################
### Install minimal build tools and remove cache. Don't do any update

RUN apk update && apk add --no-cache linux-headers \
        g++ \
        python3 \
        py-future \
        py-pip \
        libxml2-dev \
        libxslt-dev \
        git \
        && ln -sf python3 /usr/bin/python \
        &&  rm -rf /var/cache/apk/*

RUN python3 -m pip install --user --no-deps --no-cache-dir empy pexpect ptyprocess

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
FROM alpine:3.16

WORKDIR /ardupilot

RUN apk add --no-cache libstdc++

# Copy binary and defaut param file from previous image
COPY --from=builder /ardupilot/src/build/sitl/bin/arducopter .
COPY --from=builder /ardupilot/src/Tools/autotest/default_params/copter.parm .

COPY sitl_launch.sh /bin/sitl_launch.sh
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

ENTRYPOINT ["sitl_launch.sh"]
CMD ["bash"]
