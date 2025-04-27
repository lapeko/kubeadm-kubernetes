#!/usr/bin/env bash

# Install multipass on Ubuntu
sudo snap install multipass

# Install master node. Required CPUs: 2, Memory: 2GB
multipass launch --cpus 2 --memory 2048M --name master

# Install 2 worker nodes with required Memory: 2GB per machine
multipass launch --memory 2048M --name node01
multipass launch --memory 2048M --name node02
