# POC - Solana Blockchain Gift Card

## Prerequisites

This document assumes you have some virtualization software installed on your machine. I am using VirtualBox on Win10.

I am using a tool called [`multipass`](https://github.com/canonical/multipass) from Canonical ([more info](https://multipass.run/)) to spin up Ubuntu VMs.  

----

## Spin Up Simple Solana Node

To spin up an Ubuntu instance with [`solana`](https://github.com/solana-labs/solana) installed ([more info](https://docs.solana.com/introduction)) =:  

```
./spin_up_new_simple_node.sh
```

On my machine in took 1m55s to build the simple node.

```
[2022-06-21T20:43:21.816] [debug] [veteran-dory] Running: VBoxManage, startvm, veteran-dory, --type, headless

Launched: veteran-dory

real    1m54.921s
user    0m0.000s
sys     0m0.015s
```

The above script uses a Cloud Config ([more info](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)) file, `solana-config.yaml`, in addition to command line arguments passed to the `multipass` command to spin up a new instance of Ubuntu.  

This simple Solana node is able to run solana commands, but is not set up for local testnet.

:information_source: We need to build from source if we want to run the local testnet demo.

----

## Spin Up Node to Build Solana from Source

:information_source: In order to create a [local testnet](https://docs.solana.com/cluster/bench-tps), we need to build Solana from source.

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
ubuntu@tenacious-sapsucker:~$ cd solana
ubuntu@tenacious-sapsucker:~$ NDEBUG=1 ./multinode-demo/setup.sh
```

### Note on "Illegal Instruction" Error

During generation of genesis, I ran into issue of `Illegal Instruction`, probably due to lack of AVX due to Hyper-V. Apparently, AVX and Hypervisor are mutually exclusive.

I followed the steps [here to disable Hyper-V](https://stackoverflow.com/a/68214280). On Step 3 of that StackOverflow link, I had to change `Microsoft-Hyper-V` to `HypervisorPlatform`, otherwise it worked for me.

----
