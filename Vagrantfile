# -*- mode: ruby -*-
# vi: set ft=ruby :
#^syntax detection
nodes_config = (JSON.parse(File.read("config/nodes.json"))) ['nodes']

Vagrant.configure(2) do | config |
  config.vm.box = 'puppetlabs/centos-7.2-64-puppet'
  config.vm.box_check_update = true

  config.ssh.forward_agent = true

  nodes_config.each do | node |
   node_name   = node[0]
   node_values = node[1]
  end
end
