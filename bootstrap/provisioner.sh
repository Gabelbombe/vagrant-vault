#!/bin/bash
cd /root/

## update/upgrade
yum update -y
yum upgrade -y
yum makecache fast

## install reqs
yum install -y curl unzip epel-release yum-utils nginx vim ca-certificates jq

## create struct
mkdir -p /opt/vault

mkdir -p /opt/consul/{server,bootstrap} \
         /opt/consul-template           \
         /opt/consul-ui

mkdir -p /var/lib/consul

## Consul installation switch
if [[ ! -f /usr/local/bin/consul ]] ; then
  curl -L -o consul.zip https://dl.bintray.com/mitchellh/consul/0.5.2_linux_amd64.zip
  unzip consul.zip
  rm -f $_

  mv consul /usr/local/bin

  curl -L -o consul-ui.zip https://dl.bintray.com/mitchellh/consul/0.5.2_web_ui.zip
  unzip consul-ui.zip
  rm -f $_

  mv dist/ /opt/consul-ui
fi

## Vault installation switch
if [[ ! -f /usr/local/bin/vault ]] ; then
  curl -L -o vault.zip https://dl.bintray.com/mitchellh/vault/vault_0.2.0_linux_amd64.zip
  unzip vault.zip
  rm -f $_

  mv vault /usr/local/bin
fi

## consul templating switch
if [[ ! -f /usr/local/bin/consul-template ]] ; then
  curl -L -o consul-template.zip https://github.com/hashicorp/consul-template/releases/download/v0.10.0/consul-template_0.10.0_linux_amd64.tar.gz
  tar -xf consul-template.zip
  rm -f $_

  mv consul-template_0.10.0_linux_amd64/consul-template /usr/local/bin
  rm -rf consul-template_0.10.0_linux_amd64
fi

chmod a+x /usr/local/bin/*
chown -R root:root /usr/local/bin/*

## its annoying, sue me
if [[ ! $(grep '/usr/local/bin' /root/.bash_profile) ]] ; then
  echo -e 'export PATH=$PATH:/usr/local/bin'              >> /root/.bash_profile
  echo -e 'export PATH=$PATH:/usr/local/bin'              >> /vagrant/.bash_profile
  echo -e 'export VAULT_ADDR="https://$(hostname):8200"'  >> /vagrant/.bash_profile
  echo -e 'export VAULT_ADDR="https://$(hostname):8200"'  >> /root/.bash_profile
  echo -e 'alias l="ls -lah"'                             >> /root/.bash_profile
  echo -e 'alias l="ls -lah"'                             >> /vagrant/.bash_profile

  echo -e 'alias vi=/usr/bin/emacs -nw'
  echo -e 'alias vi=/usr/bin/emacs -nw'
fi

cp '/vagrant/vault.hcl'               '/etc/vault/vault.hcl'
cp '/vagrant/consul-bootstrap.json'   '/etc/consul/bootstrap/config.json'
cp '/vagrant/consul-server.json'      '/etc/consul/server/config.json'
cp '/vagrant/consul.service'          '/etc/systemd/system/consul.service'
cp '/vagrant/vault.service'           '/etc/systemd/system/vault.service'
