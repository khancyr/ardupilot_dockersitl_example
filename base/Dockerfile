# syntax=docker/dockerfile:1
FROM ardupilot_base AS builder

WORKDIR /ardupilot

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
FROM ubuntu:20.04

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
