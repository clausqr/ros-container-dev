# Develope ROS2 code in a Containarized Environment

## Benefits:

1. **Isolation:** Containers provide a self-contained environment for your ROS2 code, separating it from the host system and other applications. This isolation ensures that your code and its dependencies are encapsulated and do not interfere with other software on your machine. It also helps in avoiding conflicts between different versions of libraries or packages.
2. **Reproducibility:** By using containers, you can create a reproducible development environment. You can define the exact versions of ROS2, libraries, and dependencies required for your project in a container image. This ensures that anyone working on the project, regardless of their operating system or setup, can easily replicate the same development environment. It eliminates the "works on my machine" problem and makes collaboration easier.
3. **Portability:** Containers are highly portable. Once you have created a container image with your ROS2 code and its dependencies, you can run it on any machine that supports Docker or any other container runtime. This makes it easier to deploy your code across different platforms, such as development machines, servers, or even cloud environments, without worrying about compatibility issues.
4. **Consistency:** Containerization helps in maintaining consistency across different stages of the software development lifecycle. You can use the same container image for development, testing, and deployment, ensuring that the code behaves consistently in each environment. This reduces the chances of unexpected issues arising due to differences in the underlying system configurations.
5. **Scalability:** Containers provide a scalable approach to developing ROS2 code. You can easily spin up multiple containers to simulate a distributed ROS2 system, with each container representing a different node or component. This allows you to test and validate your code in a distributed environment without the need for physical hardware.

Developing ROS2 code in a containerized environment promotes better code organization, reproducibility, portability, consistency, and scalability. It simplifies the development process and enhances collaboration among team members.

Here is a collection of Docker images and run scripts to build and run the containers. 

They are derived from the [dockwater](https://github.com/Field-Robotics-Lab/dockwater) project.

## Usage under Ubuntu 22.04 and ROS2 Humble

### Getting started

1. [Install docker](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)
``` bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
2. Add the docker repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

3. We are using nvidia-docker, so [install nvidia-docker2](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
``` bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
  && \
    sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
sudo systemctl restart containerd
```

4. Install rocker
``` bash
pip3 install rocker
```

5. Clone this repository and cd into it
``` bash
git clone https://github.com/clausqr/ros-container-dev
cd ros-container-dev
```

6. Tune the Dockerfile for your distro and dev needs under
`<distro_name>/ros2_ws/Dockerfile`. There you may include all the libraries and dependencies that will be available inside the container for your code to build and run.

A sample Dockerfile is provided, and the default local workspace for ROS development is `/ros2_ws`.

6. Build the dev image
``` bash
bash build.bash <distro> <your-repo-url>
```

For example:
```
bash build.bash humble https://github.com/super-pkg
```

At this step the repo will be cloned to `<distro_name>/ros2_ws/src/<repo_name>`.

7. Code!

Edit your code under `<distro_name>/ros2_ws/src/<repo_name>`.
You can tune how to run your code by editing `<distro_name>/drun.bash`.

8. run, debug, etc.

To get a terminal into your container:

``` bash
bash run.bash <distro> <image_name>
```

For example:
```
bash run.bash humble super-pkg:humble
```