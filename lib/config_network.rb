# -*- mode: ruby -*-
# vi: set ft=ruby :
 
def build_hosts_list(env_vms)

  int_id = 10

  base_vars = File.open(VAGRANT_VMENV_PATH + "/provisioning/base-vars.yml", "w")

  first = true
  env_vms.each do |vm, vmconfig|
    vmconfig["networks"].each do |name, netcfg|
      if netcfg["type"] == "private" then
        if netcfg['ip'].nil? then
          netcfg['ip'] = "192.168.50." + int_id.to_s
          int_id += 1
        end
        if first then 
          base_vars.puts "---\n\nvms_hosts:"
          first = false
        end
        base_vars.puts "  #{netcfg['ip']}: #{vm}" 
      end
    end if vmconfig["networks"]
  end

  base_vars.close
 
end

def config_network(instance, vm_config)

  vm_config["networks"].each do |network, config|
    if config["type"] == "private" then
      if config["ip"] then
        instance.vm.network :private_network, ip: config["ip"]
      end
    elsif config["type"] == "public" then
      instance.vm.network :public_network
    end
  end if vm_config["networks"]

  vm_config["ports"].each do |port, config|

    raise "At least the guest port is needed in 'guest_port' variable" \
      if config["guest_port"].nil?

    instance.vm.network "forwarded_port", 
      guest: config["guest_port"],
      host: config["host_port"] || config["guest_port"], 
      protocol: config["protocol"] || "tcp",
      auto_correct: config["auto_correct"] || true
  end if vm_config["ports"]

end

