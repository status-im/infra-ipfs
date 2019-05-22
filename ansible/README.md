# Description

Herein lie all ansible related files __except__ for `ansible.cfg` at the root of the repo for easier usage without having to `cd` here.

# Usage

Simply run the playbook.
```
ansible-playbook ansible/main.yml
```

# Inventory

The inventory we use is generated from Terraform via the `terraform-provider-ansible` which generates the necessary data structures in the Consul storage that is later used by the `terraform.py` script to provide hosts and their variables to `ansible`.
