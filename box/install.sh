#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
set -ex

# install flocker
apt-get install -y apt-transport-https software-properties-common ca-certificates
add-apt-repository -y "deb https://clusterhq-archive.s3.amazonaws.com/ubuntu/$(lsb_release --release --short)/\$(ARCH) /"
cp /vagrant/apt-pref /etc/apt/preferences.d/buildbot-700
apt-get update
apt-get -y --allow-unauthenticated install clusterhq-flocker-node clusterhq-flocker-docker-plugin

# install compose
apt-get install -y docker-compose

# install aufs
apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual

# install zfs
apt-get -y install zfs

# install docker 1.13
apt-get install -y curl
curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add -
add-apt-repository "deb https://apt.dockerproject.org/repo/ ubuntu-$(lsb_release -cs) main"
apt-get update
apt-get -y install docker-engine
mkdir -p /etc/systemd/system/docker.service.d
cp /vagrant/docker.options /etc/systemd/system/docker.service.d/docker.conf
systemctl enable docker.service
usermod -aG docker ubuntu
systemctl start docker.service

# pre-pull required docker images
docker pull busybox:latest
docker pull redis:latest
docker pull binocarlos/moby-counter:latest
