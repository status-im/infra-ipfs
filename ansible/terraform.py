#! /usr/bin/env python2

import json
import os
import re
import subprocess
import sys

def _tf_env():
    # way to figure out currenly used TF workspace
    try:
        with open(TERRAFORM_ENV) as f:
            return f.read()
    except:
        return 'default'

TERRAFORM_PATH = os.environ.get('ANSIBLE_TF_BIN', 'terraform_0.11')
TERRAFORM_DIR = os.environ.get('ANSIBLE_TF_DIR', os.getcwd())
TERRAFORM_BPK = os.path.join(TERRAFORM_DIR, '.terraform/terraform.tfstate.backup')
TERRAFORM_ENV = os.path.join(TERRAFORM_DIR, '.terraform/environment')
ANSIBLE_BKP = os.path.join(TERRAFORM_DIR, 'ansible/inventory', _tf_env())

def _extract_dict(attrs, key):
    out = {}
    for k in attrs.keys():
        match = re.match(r"^" + key + r"\.(.*)", k)
        if not match or match.group(1) == "%":
            continue

        out[match.group(1)] = attrs[k]
    return out

def _extract_list(attrs, key):
    out = []

    length_key = key + ".#"
    if length_key not in attrs.keys():
        return []

    length = int(attrs[length_key])
    if length < 1:
        return []

    for i in range(0, length):
        out.append(attrs["{}.{}".format(key, i)])

    return out

def _init_group(children=None, hosts=None, vars=None):
    return {
        "hosts": [] if hosts is None else hosts,
        "vars": {} if vars is None else vars,
        "children": [] if children is None else children
    }

def _add_host(inventory, hostname, groups, host_vars):
    inventory["_meta"]["hostvars"][hostname] = host_vars
    for group in groups:
        if group not in inventory.keys():
            inventory[group] = _init_group(hosts=[hostname])
        elif hostname not in inventory[group]:
            inventory[group]["hosts"].append(hostname)

def _add_group(inventory, group_name, children, group_vars):
    if group_name not in inventory.keys():
        inventory[group_name] = _init_group(children=children, vars=group_vars)
    else:
        # Start out with support for only one "group" with a given name
        # If there's a second group by the name, last in wins
        inventory[group_name]["children"] = children
        inventory[group_name]["vars"] = group_vars

def _init_inventory():
    return {
        "all": _init_group(),
        "_meta": {
            "hostvars": {}
        }
    }

def _handle_host(attrs, inventory):
    host_vars = _extract_dict(attrs, "vars")
    groups = _extract_list(attrs, "groups")
    hostname = attrs["inventory_hostname"]

    if "all" not in groups:
        groups.append("all")

    _add_host(inventory, hostname, groups, host_vars)

def _handle_group(attrs, inventory):
    group_vars = _extract_dict(attrs, "vars")
    children = _extract_list(attrs, "children")
    group_name = attrs["inventory_group_name"]

    _add_group(inventory, group_name, children, group_vars)

def _walk_state(tfstate, inventory):
    for module in tfstate["modules"]:
        for resource in module["resources"].values():
            if not resource["type"].startswith("ansible_"):
                continue

            attrs = resource["primary"]["attributes"]

            if resource["type"] == "ansible_host":
                _handle_host(attrs, inventory)
            if resource["type"] == "ansible_group":
                _handle_group(attrs, inventory)

    return inventory

def _backup_tf(tfstate):
    # Crates a state backup in case we lose Consul
    with open(TERRAFORM_BPK, 'w') as f:
        f.write(json.dumps(tfstate))

def _backup_ansible(inventory):
    # Crates a state backup in Ansible inventory format
    text = '# NOTE: This file is generated by terraform.py\n'
    text += '# For emergency use when Consul fails\n'
    text += '[all]\n'
    for host in inventory['_meta']['hostvars'].values():
        text += (
            '{hostname} hostname={hostname} ansible_host={ansible_host} '+
            'env={env} stage={stage} data_center={data_center} region={region} '+
            'dns_entry={dns_entry}\n'
        ).format(**host)
    text += '\n'
    for name, hosts in inventory.iteritems():
        if name == '_meta':
            continue
        text += '[{}]\n'.format(name)
        for host in hosts['hosts']:
            text += '{}\n'.format(host)
        text += '\n'
    with open(ANSIBLE_BKP, 'w') as f:
        f.write(text)

def _main():
    try:
        tf_command = [TERRAFORM_PATH, 'state', 'pull', '-input=false']
        proc = subprocess.Popen(tf_command, cwd=TERRAFORM_DIR, stdout=subprocess.PIPE)
        tfstate = json.load(proc.stdout)
        # format state for ansible
        inventory = _walk_state(tfstate, _init_inventory())
        # print out for ansible
        sys.stdout.write(json.dumps(inventory, indent=2))
        # backup raw TF state
        _backup_tf(tfstate)
        # backup ansible inventory
        _backup_ansible(inventory)
    except Exception as ex:
        print(ex)
        sys.exit(1)

if __name__ == '__main__':
    _main()
