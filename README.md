# Ubuntu 14.04 LTS (Trusty) Ansible Test Image

**This image is not currently aimed at public consumption. It exists as an internal tool for testing [Ansible](http://www.ansibleworks.com/) development.**

## About

This is an image for testing Ansible playbooks and roles.

## Build

To build this as a Docker image, clone the repository and from within the project directory run:

```bash
docker build -t docker-ansible-ubuntu .
```

## Usage

- Run a container from the image:

  ```
  docker run --detach --privileged \
    --volume=$(pwd):/etc/ansible/roles/test_role:ro \
    petemcw/docker-ansible-ubuntu:latest /sbin/init
  ```

- Run Ansible inside the container:

  ```
  docker exec --tty <CONTAINER ID> env TERM=xterm ansible --version
  docker exec --tty <CONTAINER ID> env TERM=xterm \
    ansible-playbook /etc/ansible/roles/test_role/tests/test.yml --syntax-check
  ```
