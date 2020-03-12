# Description

This role configures a [systemd timer](https://www.freedesktop.org/software/systemd/man/systemd.timer.html) that runs [ipfs-sync](https://github.com/graphprotocol/ipfs-sync) daily to sync pinned content with another IPFS cluster.

# Configuration

```yaml
ipfs_sync_src_url: 'http://localhost:9094'
ipfs_sync_dest_url: 'https://another.ipfs.cluster/api/'
```
