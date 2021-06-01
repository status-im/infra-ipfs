# Description

This role configures an [IPFS Cluster](https://cluster.ipfs.io/).

To run it we use the [ipfs-cluster](https://hub.docker.com/r/ipfs/ipfs-cluster/) container using [Docker Compose](https://docs.docker.com/compose/).

See [the documentation](https://cluster.ipfs.io/documentation/) for more details.

# Details

This cluster is composed mostly out of two pieces of software:

* [IPFS](https://docs.ipfs.io/) - The distributed file storage system.
* [IPFS Cluster](https://cluster.ipfs.io/documentation/) - Orchestrates IPFS daemons running on different hosts.

The reason we need the Cluster is because it allows us to share a [pinset](https://docs.ipfs.io/guides/concepts/pinning/) which lists the CIDs([Content Identifiers](https://docs.ipfs.io/guides/concepts/cid/)) which are cluster pinned.

The cluster peers talk to one another using [libp2p](https://libp2p.io/). All the peers can safely talk to one another because the share a __secret key__ which is a 32-bit hex encoded random string.

# Ports

There are 4 ports exposed by this container:

* `5001` - Admin API port. Used by `ipfs-cluster-ctl`. Should __never__ be public.
* `9094` - Cluster REST API port.
* `9095` - IPFS Service Admin Proxy port. Should __never__ be public.
* `9096` - Cluster [Raft](https://en.wikipedia.org/wiki/Raft_(computer_science)) port. Should be public.

# Configuration

The main three parts of configuration required are the domain and the shared secret.
```yaml
# will be used for configuring the nginx proxy
ipfs_cluster_domain: ipfs.example.org
# needs to be the same for all cluster members
ipfs_cluster_secret: 9a420ec947512b8836d8eb46e1c56fdb746ab8a78015b9821e6b46b38344038f
# name of the container to connect to
ipfs_cluster_service_cont: my-ipfs-container
ipfs_cluster_service_port: 5001
```

# Known Issues

* [Raft](https://en.wikipedia.org/wiki/Raft_(computer_science)) protocol is sensitive to cluster setup changes and can have trouble finding a leader.
    - The solution to that might be adding hosts one by one, or just removing the `raft` directory from `/docker/ipfs-cluster/data` folders and restarting everything.

# Links

* https://cluster.ipfs.io/documentation/
* https://cluster.ipfs.io/documentation/starting/
* https://cluster.ipfs.io/documentation/developer/api/
