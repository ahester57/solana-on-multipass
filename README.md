# POC - Solana Blockchain Gift Card

## Prerequisites

This document assumes you have some virtualization software installed on your machine. I am using VirtualBox on Win10.

I am using a tool called [`multipass`](https://github.com/canonical/multipass) ([more info](https://multipass.run/)) from Canonical to spin up Ubuntu VMs.  

----

## Spin Up Simple Solana Node

To spin up an Ubuntu instance with [`solana`](https://github.com/solana-labs/solana) ([more info](https://docs.solana.com/introduction))installed:  

```
./spin_up_new_simple_node.sh
```

The above script uses a Cloud Config ([more info](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)) file, `solana-config.yaml`, in addition to command line arguments passed to the `multipass` command to spin up a new instance of Ubuntu.  

This simple Solana node is able to run solana commands, but is not set up for local testnet.

:information_source: We need to build from source if we want to run the local testnet demo.

----

## Spin Up Node to Build Solana from Source

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

----

## Shell Into Solana Builder to Run Multi-Node Demo

Once the rust build is complete, connect to the new instance. In this example the name of the instance is `tenacious-sapsucker`. Yours will most likely be different.

To access the Ubuntu instance: 

```
ahester@DESKTOP:~$ multipass shell tenacious-sapsucker
```

### Generate Genesis

You will now be in a virtual Ubuntu bash shell. To [setup the multi-node demo](https://docs.solana.com/cluster/bench-tps#configuration-setup):

```
ubuntu@tenacious-sapsucker:~$ ./solana/multinode-demo/setup.sh
```

----
