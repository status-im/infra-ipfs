# Getting Started

All you should need to do is:
```bash
make
```
But there are some caveats:

## Secrets

In order to use this you will need secrets(passwords, certs, keys) contained within the [infra-pass](https://github.com/status-im/infra-pass) repository.

If you can't see it ask [@jakubgs](mailto:jakub@status.im) or anyone from [DevOps Team](https://github.com/orgs/status-im/teams/devops) to get you access for it.

In order for this to work first you need to install necessary Terraform plugins and get the right secrets from the [infra-pass](https://github.com/status-im/infra-pass) repo, to do that simply run:
```
make secrets
```
This will put the necessary certificates, keys, and passwords are in place so you can deploy and configure hosts.

## Dependencies

Working with this repo requires several things:

* [Terraform](https://www.terraform.io/) [Provisioners](https://www.terraform.io/docs/provisioners/index.html) and [Providers](https://www.terraform.io/docs/providers/)
* [Ansible](https://docs.ansible.com/) [Roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)

These can be installed using.
```bash
make deps
```

# Usage

To start work on a fleet you need to select a Terraform workspace.

You can see currently existing fleets using following command:
```bash
terraform workspace list
* default
  prod
  test
```
```bash
terraform workspace select prod
```
You can view the current state of the fleet using:
```bash
terraform show
ansible localhost -m debug -a 'var=groups'
```
Then plan your fleet and if everything looks good provision it:
```bash
terraform plan
terraform apply
```
Once provisioned you can configure the hosts using Ansible:
```bash
ansible-playbook ansible/main.yml
```
Once finished your hosts should be accessible via SSH:
```bash
ssh ${USER}@node-01.xyz.prod.status.im
```

# Workspaces

Each Terraform `workspace` has it's own path in the dynamic inventory store in [Consul](https://www.consul.io/) and is a separate fleet of hosts.
You can create a new fleet and see it's current state of the fleet:
```bash
terraform workspace new beta
```
The name of your workspace will be used in the DNS names of your hosts, for example:
```
mail-01.bug-test-01.xyz.beta.status.im
```
And it's state will be saved in the [Consul](https://www.consul.io/) cluster managed by the [infra-hq](https://github.com/status-im/infra-hq) repo.

# Details

For more details read our [`infra-docs`](https://github.com/status-im/infra-docs) repo:

* [Terraform and Ansible](https://github.com/status-im/infra-docs/blob/master/articles/ansible_terraform.md)
* [Infra Naming Conventions](https://github.com/status-im/infra-docs/blob/master/articles/naming_conventions.md)
* [Infra Tips & Tricks](https://github.com/status-im/infra-docs/blob/master/articles/infra_tips_n_tricks.md)

Or refer to `README.dm` files in specific Ansible roles and Terraform modules.
