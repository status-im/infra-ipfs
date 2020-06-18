# Description

This role deploys a Docker container of [auto-sticker-pinner](https://github.com/status-im/auto-sticker-pinner) alongside a light synced Geth instance and an IPFS cluster for the purpose of automatically pinning newly added Sticker Packs to the cluster.

# Configuration

The crucial part is knowing which contract to monitor:

```yml
auto_sticker_pinner_contract: '0x0577215622f43a39F4Bc9640806DFea9b10D2A36'
auto_sticker_pinner_events: 'ContenthashChanged,Register'
auto_sticker_pinner_log_level: 'INFO'
auto_sticker_pinner_pin_all: true

auto_sticker_pinner_geth_cont_name: 'synced-geth-container'
auto_sticker_pinner_geth_cont_port: 8545

auto_sticker_pinner_ipfs_cluster_service: 'ipfs-cluster'
```

Other than that the service requires a synced Geth instance with open JSON RPC port for querying contract methods, and an IPFS Cluster admin API to pin the found sticker packs.

# Known Issues

This software has been tested on Goerli network and detected the monitored events fine, but at the time of writing this it has not been tested on Mainnet. It detects and pins currently existing packs fine, but the real test will be once a new pack arrives.
