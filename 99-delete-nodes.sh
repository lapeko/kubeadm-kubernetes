#!/bin/bash

source ./vars.sh

multipass delete "${NODES[@]}"
multipass purge