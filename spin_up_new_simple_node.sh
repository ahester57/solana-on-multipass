#!/bin/bash

time multipass launch 20.04 --mem 4G --disk 20G --timeout 360 -n simple-node --cloud-init solana-simple.yaml -vvvv
#multipass mount ./build_mount/ simple-node:/home/ubuntu/build_mount -vvvv
#TODO