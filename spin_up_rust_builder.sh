#!/bin/bash

time multipass launch 20.04 --mem 4G --disk 20G --timeout 8000 --cloud-init solana-rust-builder.yaml -vvvv
