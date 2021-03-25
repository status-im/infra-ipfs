# Description

[IPFS](https://ipfs.io/) clusters configuration.

For more details see ehese `README` files:

* [UPFS Usage](ansible/roles/ipfs-service/USAGE.md) - How to use exposed API.
* [ipfs-service](ansible/roles/ipfs-service) - The IPFS service itself.
* [ipfs-cluster](ansible/roles/ipfs-cluster) - Software for clustering IPFS.
* [auto-sticker-pinner](ansible/roles/auto-sticker-pinner) - Pinning of Dap.ps images.

# Endpoints

|                     |                             |
|---------------------|-----------------------------|
| Public IPFS Gateway | https://ipfs.status.im/     |
| Public IPFS API     | https://ipfs.status.im/api/ |

# Image Pinning

On the `sync` host runs [auto-sticker-pinner](https://github.com/status-im/auto-sticker-pinner) which listens for events on Dap.ps contract and automatically pins Dapp images to our cluster.

You can manage all three using Docker Compose:
```
admin@sync-01.gc-us-central1-a.ipfs.prod:/docker/auto-sticker % docker-compose -f docker-compose.yml -f docker-compose.pinner.yml -f docker-compose.exporter.yml ps
        Name                       Command               State                                                      Ports                                                    
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
auto-sticker-exporter   geth_exporter -ipc /data/g ...   Up      0.0.0.0:9200->9200/tcp                                                                                      
auto-sticker-node       geth --v5disc --syncmode=l ...   Up      0.0.0.0:30303->30303/tcp, 0.0.0.0:30303->30303/udp, 0.0.0.0:6060->6060/tcp, 127.0.0.1:8545->8545/tcp,       
                                                                 0.0.0.0:8546->8546/tcp                                                                                      
auto-sticker-pinner     /app/main.py --pin-all --g ...   Up
```

# Repo Usage

For how to use this repo read the [Infra Repo Usage](https://github.com/status-im/infra-docs/blob/master/articles/infra_repo_usage.md) doc.
