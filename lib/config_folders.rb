# -*- mode: ruby -*-
# vi: set ft=ruby :
 
def config_folders(instance, vm_config)
 
  instance.vm.synced_folder ".", "/vagrant"

  vm_config["folders"].each do |folder, config|
    instance.vm.synced_folder config["src"], config["dest"]
  end if vm_config["folders"]
end

