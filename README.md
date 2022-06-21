# POC - Solana Blockchain Gift Card

I am using a tool called [`multipass`](https://github.com/canonical/multipass) ([more info](https://multipass.run/) from Canonical to spin up Ubuntu VMs.  

This document assumes you have some virtualization software installed on your machine.

To spin up an Ubuntu instance with [`solana`](https://github.com/solana-labs/solana) installed:  

```
./spin_up_new_node.sh
```

The above script uses `solana-config.yaml` in addition to command line arguments passed to the `multipass` command to spin up a new instance of Ubuntu.
