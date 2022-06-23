#!/bin/bash

time multipass launch 20.04 --mem 4G --disk 10G --timeout 360 -n solana-quick-node --cloud-init solana-from-binaries.yaml -vvvv
multipass mount build_mount/ solana-quick-node:/home/ubuntu/build_mount -vvvv

MSYS_NO_PATHCONV=1 multipass exec solana-quick-node -- mkdir -p /home/ubuntu/.local/share/solana/install/manual_build
MSYS_NO_PATHCONV=1 multipass exec solana-quick-node -- cp -r /home/ubuntu/build_mount/manual_build/bin /home/ubuntu/.local/share/solana/install/manual_build/
MSYS_NO_PATHCONV=1 multipass exec solana-quick-node -- chmod -R 700 /home/ubuntu/.local/share/solana/install/manual_build/bin
multipass umount solana-quick-node -vvvv
