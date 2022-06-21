#!/bin/bash
sudo apt update
sudo apt upgrade
sudo apt autoremove
sudo apt install build-essential gcc-multilib libssl-dev
sudo apt-get install libssl-dev libudev-dev pkg-config zlib1g-dev llvm clang cmake make libprotobuf-dev protobuf-compiler

curl --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env

rustup update
rustup component add rustfmt

git clone https://github.com/solana-labs/solana.git
cd solana
./scripts/cargo-install-all.sh .
export SOLANA_BIN="$(pwd)/bin"
echo $SOLANA_BIN
echo 'export PATH=$SOLANA_BIN:"$PATH"' >> ~/.profile
# source ~/.profile

#multipass launch 20.04 --mem 4G --disk 20G --timeout 8000 --cloud-init solana-config.yaml -vvvv
#time multipass launch 20.04 --mem 4G --disk 20G --timeout 8000 --cloud-init solana-config.yaml -vvvv