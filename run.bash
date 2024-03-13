#!/usr/bin/env bash

#
# Copyright (C) 2018 Open Source Robotics Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Runs a docker container with the image created by build.bash
# Requires:
#   docker
#   nvidia-docker
#   an X server
#   rocker
# Recommended:
#   A joystick mounted to /dev/input/js0 or /dev/input/js1
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Runs a docker container with the image created by setup.bash."
   echo
   echo "Syntax: scriptTemplate [-c|]"
   echo "options:"
   echo "c     Add cuda library support."
   echo
}


JOY=/dev/input/js0
CUDA=""

# Extract image name from arguments
IMG_NAME=$1

ROCKER_ARGS="--devices $JOY --dev-helpers --nvidia --x11 --user --git --volume $(pwd)/ros2_ws:/ros2_ws"


# Replace `:` with `_` to comply with docker container naming
# And append `_runtime`
CONTAINER_NAME="$(tr ':' '_' <<< "$IMG_NAME")_runtime"
ROCKER_ARGS="${ROCKER_ARGS} --name $CONTAINER_NAME"

echo "Using image <$IMG_NAME> to start container <$CONTAINER_NAME>"


rocker ${CUDA} ${ROCKER_ARGS} $IMG_NAME 
