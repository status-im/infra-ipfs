#!/usr/bin/env bash

OS = $(strip $(shell uname -s))
ARCH = linux_amd64
ifeq ($(OS),Darwin)
	ARCH = darwin_amd64
endif

PLUGIN_DIR = ~/.terraform.d/plugins

PROVISIONER_NAME = terraform-provisioner-ansible
PROVISIONER_VERSION = v2.3.0
PROVISIONER_ARCHIVE = $(PROVISIONER_NAME)-$(subst _,-,$(ARCH))_$(PROVISIONER_VERSION)
PROVISIONER_URL = https://github.com/radekg/terraform-provisioner-ansible/releases/download/$(PROVISIONER_VERSION)/$(PROVISIONER_ARCHIVE)

all: requirements install-provisioner secrets init-terraform
	@echo "Success!"

plugins: install-provisioner

requirements:
	ansible-galaxy install --ignore-errors --force -r ansible/requirements.yml

check-unzip:
ifeq (, $(shell which unzip))
	$(error "No unzip in PATH, consider doing apt install unzip")
endif

install-provisioner:
	if [ ! -e $(PLUGIN_DIR)/$(ARCH)/$(PROVISIONER_NAME)_$(PROVISIONER_VERSION) ]; then \
		mkdir -p $(PLUGIN_DIR); \
		wget $(PROVISIONER_URL) -O $(PLUGIN_DIR)/$(ARCH)/$(PROVISIONER_NAME)_$(PROVISIONER_VERSION); \
		chmod +x $(PLUGIN_DIR)/$(ARCH)/$(PROVISIONER_NAME)_$(PROVISIONER_VERSION); \
	fi

init-terraform:
	terraform init -upgrade=true

secrets:
	pass services/consul/ca-crt > ansible/files/consul-ca.crt
	pass services/consul/ca-key > ansible/files/consul-ca.key
	pass services/consul/client-crt > ansible/files/consul-client.crt
	pass services/consul/client-key > ansible/files/consul-client.key
	pass cloud/GoogleCloud/json > google-cloud.json
	echo "Saving secrets to: terraform.tfvars"
	@echo "\
# secrets extracted from password-store\n\
cloudflare_token    = \"$(shell pass cloud/Cloudflare/token)\"\n\
cloudflare_email    = \"$(shell pass cloud/Cloudflare/email)\"\n\
cloudflare_account  = \"$(shell pass cloud/Cloudflare/account_id)\"\n\
digitalocean_token  = \"$(shell pass cloud/DigitalOcean/token)\"\n\
alicloud_access_key = \"$(shell pass cloud/Alibaba/access-key)\"\n\
alicloud_secret_key = \"$(shell pass cloud/Alibaba/secret-key)\"\n\
" > terraform.tfvars

cleanup:
	rm -r $(PLUGIN_DIR)/$(ARCHIVE)
