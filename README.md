# Description

[IPFS](https://ipfs.io/) clusters configuration. Read [role README](ansible/roles/ipfs-cluster) for more info.

# Requirements

In order to use this you will need secrets(passwords, certs, keys) contained within the [infra-pass](https://github.com/status-im/infra-pass) repository. If you can't see it ask jakub@status.im to get you access for it.

In order for this to work first you need to install necessary Terraform plugins and get the right secrets from the [infra-pass](https://github.com/status-im/infra-pass) repo, to do that simply run:
```
make
# alternatively
make plugins
make secrets
```
This will put the necessary certificates, keys, and passwords are in place so you can deploy and configure hosts.

# Usage

To provision a new fleet create a new Terraform workspace:
```
terraform workspace new bug-test
```
Then plan your fleet and if everything looks good provision it:
```
terraform plan
terraform apply
```
Once provisioned you can configure the hosts using Ansible:
```
ansible-playbook ansible/main.yml
```
Once finished your hosts should be accessible via SSH:
```
ssh ${USER}@node-01.ipfs.prod.status.im
```

# Workspaces

Each Terraform `workspace` has it's own path in the dynamic inventory and is a separate fleet of hosts.
You can see currently existing fleets using following command:
```
terraform workspace list
  default
* prod
  test
```
You can select a fleet and see it's current state of the fleet:
```
terraform workspace select test
terraform show
```
Or create a new workspace for yourself.
```
terraform workspace new bug-test-01
```
The name of your workspace will be used in the DNS names of your hosts, for example:
```
mail-01.bug-test-01.ipfs.f.status.im
```
And it's state will be saved in the [Consul](https://www.consul.io/) cluster managed by the [infra-hq](https://github.com/status-im/infra-hq) repo.

# Details

Read the [Terraform and Ansible](https://github.com/status-im/infra-docs/blob/master/articles/ansible_terraform.md) article in our `infra-docs` repo.
