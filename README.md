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

More on this to come...
