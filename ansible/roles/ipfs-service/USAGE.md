# Into

For details on how to use IPFS you can read about:

* [Core Concepts](https://docs.ipfs.io/guides/concepts/)
* [File Transfers](https://github.com/ipfs/go-ipfs/blob/master/docs/file-transfer.md)
* [IPFS for Websites](https://docs.ipfs.io/guides/examples/websites/)
* [HTTP Admin API](https://docs.ipfs.io/reference/api/http/)

# Public Admin API

Some of the Admin API calls are exposed to the public on the `2053` port:

* [`/api/v0/id`](https://docs.ipfs.io/reference/api/http/#api-v0-id) - Show ipfs node id info.
* [`/api/v0/get`](https://docs.ipfs.io/reference/api/http/#api-v0-get) - Download IPFS objects.
* [`/api/v0/add`](https://docs.ipfs.io/reference/api/http/#api-v0-add) - Add a file or directory to IPFS.
* [`/api/v0/pin/add`](https://docs.ipfs.io/reference/api/http/#api-v0-pin-add) - Pin objects to local storage.
* [`/api/v0/pin/rm`](https://docs.ipfs.io/reference/api/http/#api-v0-pin-rm) - Remove pinned objects from local storage.
* [`/api/v0/pin/ls`](https://docs.ipfs.io/reference/api/http/#api-v0-pin-ls) - List objects pinned to local storage.
* [`/api/v0/object/get`](https://docs.ipfs.io/reference/api/http/#api-v0-object-get) - Get and serialize the DAG node named by .

You can check details here:

* [ansible/group_vars/ipfs.yml](ansible/group_vars/ipfs.yml)

# Example

Here's an example of uploading and pinning a file.

1. Create a file to upload:
  ```
   $ echo "sup my dude" > hello
  ```

2. Upload the file using part of API exposed on port `2053`:
  ```
   $ curl -F file=@hello 'https://test-ipfs.status.im:2053/api/v0/add?pin=true'                                     
  {"Name":"hello","Hash":"QmZdER7pR3S4NCri89kf5qVEZfDWvFSwLEYyAWRWdwQgHt","Size":"20"}
  ```

3. Check availability of the file using the `object/get` call:
  ```
   $ curl -s 'https://test-ipfs.status.im:2053/api/v0/object/get?arg=QmZdER7pR3S4NCri89kf5qVEZfDWvFSwLEYyAWRWdwQgHt'
  {"Links":[],"Data":"\u0008\u0002\u0012\u000csup my dude\n\u0018\u000c"} 
  ```

That file should now be available via the public gateway:

https://test-ipfs.status.im/ipfs/QmZdER7pR3S4NCri89kf5qVEZfDWvFSwLEYyAWRWdwQgHt
