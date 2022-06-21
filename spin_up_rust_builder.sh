#!/bin/bash

time multipass launch 20.04 --mem 4G --disk 25G --timeout 8000 --cloud-init solana-rust-builder.yaml -vvvv
