# POC - Solana Blockchain Gift Card

I am using a tool called [`multipass`](https://github.com/canonical/multipass) ([more info](https://multipass.run/)) from Canonical to spin up Ubuntu VMs.  

This document assumes you have some virtualization software installed on your machine.

## Spin Up Simple Solana Node

To spin up an Ubuntu instance with [`solana`](https://github.com/solana-labs/solana) ([more info](https://docs.solana.com/introduction))installed:  

```
./spin_up_new_simple_node.sh
```

The above script uses `solana-config.yaml` in addition to command line arguments passed to the `multipass` command to spin up a new instance of Ubuntu.

## Spin Up Node to Build Solana

In order to create a [local testnet](https://docs.solana.com/cluster/bench-tps), we need to build Solana from source.

To spin up an Ubuntu instance using `rust` and `cargo` to build Solana for a local testnet:

```
./spin_up_rust_builder.sh
```

On my machine it took 38m35s to build everything.

```
[2022-06-21T18:11:56.465] [debug] [tenacious-sapsucker] Running: VBoxManage, startvm, tenacious-sapsucker, --type, headless

Launched: tenacious-sapsucker

real    38m35.442s
user    0m0.000s
sys     0m0.015s
```

## Shell Into Solana Builder to Run Multi-Node Demo

Once the rust build is complete, connect to the new instance. In this example the name of the instance is `tenacious-sapsucker`. Yours will most likely be different.

To access the Ubuntu instance: `multipass shell tenacious-sapsucker`.

You will now be in an Ubuntu bash shell. To initiate the multi-node demo:

```
./solana/multinode-demo/setup.sh
```
