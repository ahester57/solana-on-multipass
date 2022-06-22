#!/bin/bash

time multipass launch 20.04 --mem 4G --disk 25G -n rust-builder --timeout 8000 --cloud-init solana-rust-builder.yaml -vvvv
multipass mount ./build_mount/ rust-builder:/home/ubuntu/build_mount -vvvv
multipass exec rust-builder -- cp -r .local/share/solana/install/manual_build/ build_mount/