# Description

This role configures an [IPFS Cluster](https://cluster.ipfs.io/).

To run it we use the [ipfs-cluster](https://hub.docker.com/r/ipfs/ipfs-cluster/) container.

See [the documentation](https://cluster.ipfs.io/documentation/) for more details.

# Details

This cluster is composed mostly out of two pieces of software:

* [IPFS](https://docs.ipfs.io/) - The distributed file storage system.
* [IPFS Cluster](https://cluster.ipfs.io/documentation/) - Orchestrates IPFS daemons running on different hosts.

The reason we need the Cluster is because it allows us to share a [pinset](https://docs.ipfs.io/guides/concepts/pinning/) which lists the CIDs([Content Identifiers](https://docs.ipfs.io/guides/concepts/cid/)) which are cluster pinned.

The cluster peers talk to one another using [libp2p](https://libp2p.io/). All the peers can safely talk to one another because the share a __secret key__ which is a 32-bit hex encoded random string.

# Configuration

The main two parts of configuration required are the domain and the shared secret.
```yaml
# will be used for configuring the nginx proxy
ipfs_cluster_domain: ipfs.example.org
# needs to be the same for all cluster members
ipfs_cluster_secret: 9a420ec947512b8836d8eb46e1c56fdb746ab8a78015b9821e6b46b38344038f
```

# Known Issues

* [Raft](https://en.wikipedia.org/wiki/Raft_(computer_science)) protocol is sensitive to cluster setup changes and can have trouble finding a leader.
    - The solution to that might be adding hosts one by one, or just removing the `raft` directory from `/docker/ipfs-cluster/data` folders and restarting everything.

# Links

* https://cluster.ipfs.io/documentation/
* https://cluster.ipfs.io/documentation/starting/
* https://cluster.ipfs.io/documentation/developer/api/
