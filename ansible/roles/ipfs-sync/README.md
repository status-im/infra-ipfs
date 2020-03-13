# Description

This role configures a [systemd timer](https://www.freedesktop.org/software/systemd/man/systemd.timer.html) that runs [ipfs-sync](https://github.com/graphprotocol/ipfs-sync) daily to sync pinned content with another IPFS cluster.

# Configuration

```yaml
ipfs_sync_src_url: 'http://localhost:9094'
ipfs_sync_dest_url: 'https://another.ipfs.cluster/api/'
```

# Usage

```
 $  sudo systemctl list-timers ipfs-sync.timer
NEXT                         LEFT     LAST                         PASSED  UNIT            ACTIVATES
Sat 2020-03-14 00:00:00 UTC  12h left Fri 2020-03-13 00:00:05 UTC  11h ago ipfs-sync.timer ipfs-sync.service
```
```
 $ sudo systemctl status ipfs-sync.service
● ipfs-sync.service - IPFS-Sync for syncing clusters
   Loaded: loaded (/lib/systemd/system/ipfs-sync.service; static; vendor preset: enabled)
   Active: inactive (dead) since Fri 2020-03-13 00:01:53 UTC; 11h ago
     Docs: https://github.com/status-im/infra-role-systemd-timer
  Process: 3839 ExecStart=/usr/local/bin/ipfs-sync (code=exited, status=0/SUCCESS)
 Main PID: 3839 (code=exited, status=0/SUCCESS)

Mar 13 00:01:52 node-01.gc-us-central1-a.ipfs.prod ipfs-sync[3839]: 402/404 (QmfSVWmdw36EY3qH4VLLeup18mWBrCQCkF99FEXGEDP9DX): Uploading file
Mar 13 00:01:52 node-01.gc-us-central1-a.ipfs.prod ipfs-sync[3839]: 400/404 (QmfQSGnYVj8D6EUHjpMCJUcvv5iy3UZZQz1D7P1QmnKGXS): File synced successful
Mar 13 00:01:53 node-01.gc-us-central1-a.ipfs.prod ipfs-sync[3839]: 403/404 (QmfZp8gzRrGHTPPXbCGWcjJiFmHpGjSzQWzm3iUKYWAUzY): File synced successful
Mar 13 00:01:53 node-01.gc-us-central1-a.ipfs.prod ipfs-sync[3839]: 401/404 (QmfRmsxMUBYNcpHHqmCJ5X3tkaqTu7foxghWyZ8jB4HUKw): File synced successful
Mar 13 00:01:53 node-01.gc-us-central1-a.ipfs.prod ipfs-sync[3839]: 402/404 (QmfSVWmdw36EY3qH4VLLeup18mWBrCQCkF99FEXGEDP9DX): File synced successful
Mar 13 00:01:53 node-01.gc-us-central1-a.ipfs.prod ipfs-sync[3839]: ---
Mar 13 00:01:53 node-01.gc-us-central1-a.ipfs.prod ipfs-sync[3839]: 404/404 files synced
Mar 13 00:01:53 node-01.gc-us-central1-a.ipfs.prod ipfs-sync[3839]: 0 skipped (directories)
Mar 13 00:01:53 node-01.gc-us-central1-a.ipfs.prod ipfs-sync[3839]: 0 failed
Mar 13 00:01:53 node-01.gc-us-central1-a.ipfs.prod systemd[1]: Started IPFS-Sync for syncing clusters.
```
