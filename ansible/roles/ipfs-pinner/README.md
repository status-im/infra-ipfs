# Description

This Ansible role deploys a Python script at `/usr/local/bin/ipfs-pinner` which can be used to easilly pin content hashes to the cluster.

# Usage

The simplest way is to pipe content hashes via STDIN to the script:
```
 $ cat ~/chashes | ansible/roles/ipfs-pinner/files/ipfs_pinner.py --action pin 
Qma4TLstcidGx3HCw26QkSayk4c6BK1Jz7yE2Lssp4mjQa - STATUS: {'pinning': 2}
Qma4TLstcidGx3HCw26QkSayk4c6BK1Jz7yE2Lssp4mjQa - PINNING
QmaGG9mJZCGgC2HBNTSrBArbowRMKQ2fXPpvg7aGbuw9hy - STATUS: {'pinning': 2}
QmaGG9mJZCGgC2HBNTSrBArbowRMKQ2fXPpvg7aGbuw9hy - PINNING
States: {'pinning': 2}
```

You can also inpin them:
```
 $ cat ~/chashes | ansible/roles/ipfs-pinner/files/ipfs_pinner.py --action unpin
Qma4TLstcidGx3HCw26QkSayk4c6BK1Jz7yE2Lssp4mjQa - STATUS: {'pinning': 2}
Qma4TLstcidGx3HCw26QkSayk4c6BK1Jz7yE2Lssp4mjQa - UNPINNING
QmaGG9mJZCGgC2HBNTSrBArbowRMKQ2fXPpvg7aGbuw9hy - STATUS: {'pinning': 2}
QmaGG9mJZCGgC2HBNTSrBArbowRMKQ2fXPpvg7aGbuw9hy - UNPINNING
States: {'unpinning': 2}
```
By default it just lists current states

# Configuration

```yaml
ipfs_pinner_script_path: '/usr/local/bin/ipfs-pinner'
```
