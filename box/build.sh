#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
set -e

unixsecs=$(date +%s)
vagrant destroy -f
vagrant up
vagrant package
mv package.box vagrant${unixsecs}.box
echo "Vagrant box has been created"
vagrant destroy -f
echo vagrant${unixsecs}.box
vagrant box add --name "docker-flocker" --force vagrant${unixsecs}.box
echo "create new docker-flocker"
