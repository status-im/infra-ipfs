# Description

The files here are Ansible invenotyr files generated by [`ansible/terraform.py`](/ansible/terraform.py).

Their purpose is an emergency inventory backup in case of failure or unavailability of Consul.

# Usage

To use simply provide the file for the given stage using the `-i` argument.

For example, if you want to run Ansible while Consul is unavailable do:
```bash
ansible-playbook ansible/main.yml -i ansible/inventory/beta
```

# Details

For more details on how Ansible and Terraform interact read [this article](https://github.com/status-im/infra-docs/blob/master/articles/ansible_terraform.md).
