# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'
require 'yaml'

require_relative "lib/config_provider.rb"
require_relative "lib/config_provision.rb"
require_relative "lib/config_network.rb"
require_relative "lib/config_folders.rb"

# load the .qi.yml file
qi_file = File.expand_path (".qi.yml")
if File.exists?(qi_file)
  qi_definition = YAML.load(File.read(qi_file))
else
  raise ".qi.yml file not found in this repository"
end

# load the environment based on "env_runtime" variable of .qi.yml
vagrant_env = qi_definition["env_runtime"] || "default"
environment_file = File.expand_path("envs", File.dirname(__FILE__)) +
                   File::SEPARATOR + vagrant_env
if File.exists?(environment_file + ".json")
  environment = JSON.parse(File.read(environment_file + ".json"))
elsif File.exists?(environment_file + ".yml")
  environment = YAML.load(File.read(environment_file + ".yml"))
else
  raise "Environment config file not found, see envs directory\n #{environment_file}"
end

# build the host list of the VMs used, very useful to allow the communication
# between them based on the hostname and IP stored in the hosts file
build_hosts_list(environment["vms"])

Vagrant.configure(2) do |config|

  environment["vms"].each do |vm_id, vm_config|

    config.vm.define vm_id, autostart: vm_config["autostart"] do |instance|

      # Ansible handles this task better than Vagrant
      #instance.vm.hostname = vm_id

      config_provider(instance, vm_config, environment["global"])

      config_provision(instance, vm_config, vm_id, qi_definition["apps"])

      config_network(instance, vm_config)

      config_folders(instance, vm_id, qi_definition["apps"])

    end
  end
end

