#!/bin/bash

set -e
set -x

pushd alpine
  echo "BUILDING alpine"
  docker build -t silt_alpine -f Dockerfile .
popd
pushd base
  echo "BUILDING base"
  docker build -t silt_base -f Dockerfile .
popd
pushd python
  echo "BUILDING python"
  docker build -t silt_python -f Dockerfile .
popd
pushd ubuntu
  echo "BUILDING ubuntu"
  docker build -t silt_ubuntu -f Dockerfile .
popd
