# POC - Solana on Multipass

## Prerequisites

This document assumes you have some virtualization software installed on your machine. I am using VirtualBox on Win10.

* > 15 GB of free disk space for `solana-rust-builder`
* > Additional 15 GB of free disk space for `solana-quick-node`
* > I am using a tool called [`multipass`](https://github.com/canonical/multipass) from Canonical ([more info](https://multipass.run/)) to spin up Ubuntu VMs.  

----

:information_source: We need to build from source if we want to run the local testnet demo in virtual environment without AVX CPU flags.

----

## Spin Up Ubuntu Instance to Build Solana from Source

:information_source: In order to create a [local testnet](https://docs.solana.com/cluster/bench-tps), we need to build Solana ([more info](https://docs.solana.com/introduction)) from source.

To spin up an Ubuntu instance using `rust` and `cargo` to build Solana for a local testnet:

```python
ahester@DESKTOP:~$ ./spin_up_rust_builder.sh
```

The above script uses a [Cloud Config](https://cloudinit.readthedocs.io/en/latest/topics/examples.html) file, `solana-config.yaml`, in addition to command line arguments passed to the `multipass` command to spin up a new instance of Ubuntu.

On my machine it took 47m10s to build everything.

```python
[2022-06-21T18:11:56.465] [debug] [solana-rust-builder] Running: VBoxManage, startvm, solana-rust-builder, --type, headless

Launched: solana-rust-builder

real    47m10.076s
user    0m0.000s
sys     0m0.000s
```

### Spin-Up Script Effects

After building, the `spin_up_rust_builder.sh` script then:

* Install `rust` and `cargo`.
* Mounts the source machine's `build_mount` directory to the same directory in `solana-rust-builder:~/build_mount`.
* Copies the just-built binaries from your virtual Ubuntu instance to source's `build_mount/manual_build` directory.

The `build_mount/manual_build` directory is then used to speed up launches of new instances.

*Note: The action of mounting the directory using `multipass` will install `multipass-sshfs` on the target machine using the snap store.*

----

## Shell Into Solana Builder

Once the rust build is complete, connect to the new instance. In this example the name of the instance is `solana-rust-builder`. Yours will most likely be different.

To access the Ubuntu instance:

```python
ahester@DESKTOP:~$ multipass shell solana-rust-builder
```

----

## Local Single-Node Cluster

One of the easiest ways to get a Solana [on-chain program](https://docs.solana.com/developing/on-chain-programs/overview) running is to use the [`solana_test_validator`](https://docs.solana.com/developing/test-validator).

> During early stage development, it is often convenient to target a cluster with fewer restrictions and more configuration options than the public offerings provide. This is easily achieved with the `solana-test-validator` binary, which starts a full-featured, single-node cluster on the developer's workstation.  

### Create a Test Wallet

Check you Solana wallet's balance with:

```python
solana balance
```

If you have yet to create a Solana wallet, you'll see something like:

```python
Error: Dynamic program error: No default signer found, run "solana-keygen new -o /home/ubuntu/.config/solana/id.json" to create a new one
```

Run the command it suggests to create your wallet. The output of that command on `solana-rust-builder`:

```python
ubuntu@solana-rust-builder:~$ solana-keygen new -o ~/.config/solana/id.json
Generating a new keypair

For added security, enter a BIP39 passphrase

NOTE! This passphrase improves security of the recovery seed phrase NOT the
keypair file itself, which is stored as insecure plain text

BIP39 Passphrase (empty for none):
Enter same passphrase again:

Wrote new keypair to /home/ubuntu/.config/solana/id.json
============================================================================
pubkey: D7YKR8P1wrTS7L4fVxA7ziK4UnTNnjGkFfygicgCPsu8
============================================================================
Save this seed phrase and your BIP39 passphrase to recover your new keypair:
---- -------- ------ -------- ----- -------- ------- ------ --------- -----
============================================================================
```

### Start Your Cluster

Now you can start you single-node cluster:

```python
ubuntu@solana-rust-builder:~$ solana-test-validator
Ledger location: test-ledger
Log: test-ledger/validator.log
⠲ Initializing...
⠄ Initializing...
Identity: Hnz2PxcVqZUkxrr6bbsU6ZcKn7jko1JFNAMbWLrKHXdQ
Genesis Hash: H1iw5ZNxEZQB9Qs81TfYDwM2TbyrZ2e4TERdLQpEGdNs
Version: 1.11.1
Shred Version: 54048
Gossip Address: 127.0.0.1:1024
TPU Address: 127.0.0.1:1027
JSON RPC URL: http://127.0.0.1:8899
⠠ 00:00:22 | Processed Slot: 48 | Confirmed Slot: 48 | Finalized Slot: 16 | Full
```

### Configure Your Solana CLI Tools

Next configure your Solana [CLI Tool Suite](https://docs.solana.com/cli) to use your local JSON RPC connection. Note that I am running this command from within the virtual Ubuntu instance called `solana-rust-builder`. The URL given in the command should match the `JSON RPC URL` printed by `solana-test-validator`.

```python
ubuntu@solana-rust-builder:~$ solana config set --url http://127.0.0.1:8899
Config File: /home/ubuntu/.config/solana/cli/config.yml
RPC URL: http://127.0.0.1:8899
WebSocket URL: ws://127.0.0.1:8900/ (computed)
Keypair Path: /home/ubuntu/.config/solana/id.json
Commitment: confirmed
```

#### Confirm Your CLI Configuration

To confirm the configuration is pointing at your local test network, run `solana genesis-hash` and ensure the output matches the `Genesis Hash` printed by `solana-test-validator`.

```python
ubuntu@solana-rust-builder:~$ solana genesis-hash
H1iw5ZNxEZQB9Qs81TfYDwM2TbyrZ2e4TERdLQpEGdNs
```

### Check Your Enabled Features

After configuring your Solana CLI tools to point to your local validator, you can check the feature supported by your client with:

```python
ubuntu@solana-rust-builder:~$ solana feature status -ul

...

Tool Software Version: 1.11.1
Software Version    Stake      RPC
1.11.1            100.00%  100.00%  <-- me

Tool Feature Set: 499180940
Software Version  Feature Set    Stake      RPC
1.11.1              499180940  100.00%  100.00%  <-- me
```

### Get Money

To get money:

```python
ubuntu@solana-rust-builder:~$ solana airdrop 1000000
```

----

## Spin Up Solana Node Quickly From Prebuilt Binaries

To spin up an Ubuntu instance called `solana-quick-node` with [`solana`](https://github.com/solana-labs/solana) installed from the binaries you just built above:


### Enable Networking on Multipass Instance

:warning: Before spinning up your new node, on your machine run:

```python
:~$ multipass networks
```

Choose the network you are using from the output list. Update the `time multipass launch` line's `--network` option from 'Ethernet' to whatever your network is. You do not have to do this if you do not care to connect to this node's RPC from outside the VM.

### Create Solana Quick Node

```python
:~$ ./spin_up_new_node_from_binaries.sh
```

On my machine in took 1m55s to build the node from prebuilt binaries using shared mounts.

```python
[2022-06-21T20:43:21.816] [debug] [veteran-dory] Running: VBoxManage, startvm, veteran-dory, --type, headless

Launched: veteran-dory

real    1m54.921s
user    0m0.000s
sys     0m0.015s
```

### Spin-Up Script Effects

After initializing the node with multipass, `spin_up_new_node_from_binaries.sh` will then:

* Install `rust` and `cargo`.
* Mounts the source machine's `build_mount` directory to the same directory in `solana-quick-node:~/build_mount`.
* Copies the previously-built binaries from the mounted volume to virtual Ubuntus `~/.local/share/solana/install...` directory.
* Set up target's `PATH` in `~/.profile`.

This new node should only take a couple minutes to spin up with built-from-source binaries in use.

----

## Local Multi-Node Cluster

If the Test Validator is not enough for you and you want to [setup the multi-node demo](https://docs.solana.com/cluster/bench-tps#configuration-setup):

### Generate Genesis

```python
ubuntu@solana-rust-builder:~$ cd solana
ubuntu@solana-rust-builder:~$ NDEBUG=1 ./multinode-demo/setup.sh
```

### TBA

----

## Note on "Illegal Instruction" Error

During generation of genesis, I ran into issue of `Illegal Instruction`, probably due to lack of `AVX` and `AVX2` CPU flags due to Hypervisor. Apparently, AVX and Hypervisor are mutually exclusive.

To [disable Hyper-V in Windows Powershell](https://docs.microsoft.com/en-us/troubleshoot/windows-client/application-management/virtualization-apps-not-work-with-hyper-v):

```python
Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Hypervisor
```

An alternative way to [disable Hyper-V using `cmd`](https://stackoverflow.com/a/68214280) . I had to change `Microsoft-Hyper-V` to `HypervisorPlatform`, otherwise it worked for me.

----
