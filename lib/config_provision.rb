# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

def config_provision(instance, vm_config, vm_id)

  basecmd = "sudo PYTHONUNBUFFERED=1 VM_HOSTNAME=#{vm_id} "\
            "ansible-playbook /vagrant/#{VAGRANT_VMENV_PATH}/provisioning/base-playbook.yml"
  instance.vm.provision "shell", inline: basecmd
 
  vm_config["apps"].each do |app, config|

    #check if every file is in place
    raise "File vagrant/provisioning/#{app}-requirements.yml doesn't exist"\
      unless File.file?(VAGRANT_VMENV_PATH + "/provisioning/#{app}-requirements.yml")
    raise "File vagrant/provisioning/#{app}-vars.yml doesn't exist"\
      unless File.file?(VAGRANT_VMENV_PATH + "/provisioning/#{app}-vagrant-vars.yml")
    raise "File vagrant/provisioning/#{app}-playbook.yml doesn't exist"\
      unless File.file?(VAGRANT_VMENV_PATH + "/provisioning/#{app}-playbook.yml")
    raise "File vagrant/provisioning/base-playbook.yml doesn't exist"\
      unless File.file?(VAGRANT_VMENV_PATH + "/provisioning/base-playbook.yml")

    cmds = \
    "sudo ansible-galaxy install -fr /vagrant/#{VAGRANT_VMENV_PATH}/provisioning/#{app}-requirements.yml \n"\
    "sudo VARS_FILE=#{app}-vagrant-vars.yml PYTHONUNBUFFERED=1 \\\n"
    config.each do |name, value|
      cmds << name.upcase + "=" + value.to_s + " \\\n"
    end
    if config["deploy"] then
      cmds << "ansible-playbook --tags='install,configure,deploy' /vagrant/#{VAGRANT_VMENV_PATH}/provisioning/#{app}-playbook.yml"
    else
      cmds << "ansible-playbook --tags='install,configure' /vagrant/#{VAGRANT_VMENV_PATH}/provisioning/#{app}-playbook.yml"
    end
    instance.vm.provision "shell", inline: cmds

  end if vm_config["apps"] and ARGV[0] == "up"

  vm_config["provision"].each do |type, args|
    if type == "shell" then
      shellcmds = ""
      args.each do |cmd|
        shellcmds << cmd + "\n"
      end
      instance.vm.provision "shell", privileged: false, inline: shellcmds
    end
  end if vm_config["provision"]

  qi_vars = YAML.load(File.read(".qi.yml")) if File.file?(".qi.yml")

  if !qi_vars.nil? and ARGV[0] == "provision" and vm_config["tests_here"] then
    qi_shellcmds = "cd /home/vagrant/sync \n" 
    qi_vars["setup"].each do |cmd|
      qi_shellcmds << cmd + "\n"
    end unless qi_vars["setup"].nil?
    qi_vars["commands"].each do |cmd|
      qi_shellcmds << "DISPLAY=:0 " + cmd + "\n"
    end unless qi_vars["commands"].nil?
    puts qi_shellcmds
    instance.vm.provision "shell", privileged: false, inline: qi_shellcmds
  end

end
