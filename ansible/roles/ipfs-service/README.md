# Description

This role configures an [IPFS](https://docs.ipfs.io/), a distributed file storage system.

# Details

We use the [go-ipfs](https://hub.docker.com/r/ipfs/go-ipfs/) docker container image which requires minimal configuration

There are 3 ports exposed by the container:

* `5001` - The __admin__ API port. Allows for uploading of files and needs to be protected.
* `4001` - The __swarm__ `libp2p` port. Should be open to public for other peers to use.
* `8080` - The __gateway__ and read-only API port. Exposes IPFS resources, used by Nginx proxy.

# Configuration

```yaml
# version of IPFS container to use
ipfs_cont_tag: 'v0.4.20'
# ipfs configuration adjustments
ipfs_config:
  'API.HTTPHeaders.Access-Control-Allow-Origin': ["*"]
```

# Usage

Read the [USAGE](./USAGE.md) file.

# Known Issues

Currently the Docker image does not support automatically running migrations, and those have to be performed manually by building and using the [official migration tool](https://github.com/ipfs/fs-repo-migrations).

For more details see the issue: https://github.com/ipfs/fs-repo-migrations/issues/133

# Links

* https://docs.ipfs.io/introduction/overview/
* https://medium.com/@cvcassano/protecting-an-ipfs-node-with-nginx-reverse-proxy-on-ubuntu-18-04-e56685a10bcc
* https://medium.com/coinmonks/a-hands-on-introduction-to-ipfs-ee65b594937
* https://hackernoon.com/public-ipfs-node-behind-nginx-reverse-proxy-5682747f174b?gi=88a6ba04211b
* https://github.com/ipfs/go-ipfs/issues/5610
* https://discuss.ipfs.io/t/how-should-i-configure-my-firewall/471
* https://www.ctrl.blog/entry/ipfs-repo-cache-gc.html
