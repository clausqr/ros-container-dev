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
#

# Builds a Docker image.

# Arguments:
#   $1: The link to the repository to get and setup for dev.
#   $2: The name of the image to build.

#!/usr/bin/env bash

echo "This script will build a Docker image and clone a repository to the ROS workspace inside the container while exposing the source code to the outside, for dev convenience..."
if [ -z "$1" ] || [ -z "$2" ] ; then
    echo "Usage: $0 <repo> <image_name>"
    exit 1
fi

repo=$1
image_name=$2

if [ -z "$repo" ] || [ -z "$image_name" ]; then
    echo "Missing arguments. Please provide the repository link and image name."
    exit 1
fi

image_plus_tag=$image_name:$(export LC_ALL=C; date +%Y%m%d_%H%M)

image_plus_tag_base=$image_plus_tag"-env"
image_plus_tag_run=$image_plus_tag"-run"

docker build --rm \
    -t $image_plus_tag_base \
    -f Dockerfile-env . && \
docker tag $image_plus_tag_base $image_name"-env" && \
echo "Built $image_plus_tag_base and tagged as $image_name"-env""
echo
docker build --rm -t $image_plus_tag_run \
    --build-arg BASE_IMAGE=$image_name"-env" \
    -f Dockerfile-run . && \
docker tag $image_plus_tag_run $image_name && \
echo "Built $image_plus_tag_run and tagged as $image_name"
echo

git clone $repo ./ros2_ws/src/ && \
echo "Cloned repository $repo to $(pwd)/ros2_ws/src/"
echo
echo "To run:"
echo "./run.bash $image_name"
