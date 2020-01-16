#!/usr/bin/env python3

import re
import sys
import json
import requests
import ipfscluster  # https://pypi.org/project/ipfscluster
from optparse import OptionParser
from multiaddr import Multiaddr
from collections import Counter


HELP_DESCRIPTION='''
This is a utility for pinning content hashes to an IPFS cluster via REST API.
By default it takes input from STDIN, but can be read a file via --input.
'''
HELP_EXAMPLES='''
Example: cat content_hashes | {}
'''.format(__file__)

def all_are(val, elements):
    return all(e == 'val' for e in elements)

class IpfsPinner:

    def __init__(self, addr=ipfscluster.DEFAULT_ADDR):
        self.client = ipfscluster.connect(addr)

    def is_pinned(self, chash):
        resp = self.client.pins.ls(chash)
        statuses = [peer['status'] for peer in resp['peer_map'].values()]
        # simple identifier of state across all peers
        state = 'mixed'
        for s in ['pinned', 'unpinned', 'pinning', 'pin_queue']:
            if all(e == s for e in statuses):
                state = s

        return state, dict(Counter(statuses))

    def pin(self, chash):
        return self.client.pins.add(chash)

    def unpin(self, chash):
        return self.client.pins.rm(chash)

def parse_opts():
    parser = OptionParser(
        description=HELP_DESCRIPTION,
        epilog=HELP_EXAMPLES
    )
    parser.add_option('-H', '--host', default='127.0.0.1',
                      help='Listening address of the IPFS cluster.')
    parser.add_option('-P', '--port', default=9094,
                      help='Management port of the IPFS cluster.')
    parser.add_option('-i', '--input', default=None,
                      help='Path to input file with content hashes.')
    parser.add_option('-a', '--action', default='ls',
                      type='choice', choices=('ls', 'pin', 'unpin'),
                      help='Action to take for each of the give hashes. (pin|unpin)')
    return parser.parse_args()

def main():
    (opts, args) = parse_opts()

    maddr = Multiaddr('/ip4/{}/tcp/{}/http'.format(opts.host, opts.port))
    ip = IpfsPinner(maddr)

    # by default use STDIN
    hashes_input = sys.stdin
    if opts.input:
        with open(opts.input) as f:
            hashes_input = f.readlines()

    hashes = [rhash.rstrip() for rhash in hashes_input]

    states_counter = []

    for chash in hashes:
        state, statuses = ip.is_pinned(chash)
        print('{} - STATUS: {}'.format(chash, statuses))

        if opts.action == 'pin' and state != 'pinned':
            ip.pin(chash)
            state = 'pinning'
            print('{} - PINNING'.format(chash))
        elif opts.action == 'unpin' and state in ['pinned', 'pinning', 'pin_queue']:
            ip.unpin(chash)
            state = 'unpinning'
            print('{} - UNPINNING'.format(chash))

        states_counter.append(state)

    print('States: {}'.format(dict(Counter(states_counter))))

if __name__== "__main__":
    main()
