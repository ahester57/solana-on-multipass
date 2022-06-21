#!/bin/bash

time multipass launch 20.04 --mem 4G --disk 20G --timeout 360 --cloud-init solana-simple.yaml -vvvv
