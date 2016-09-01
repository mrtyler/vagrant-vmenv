Vagrant-vmenv
=============

Vagrant-vmenv is a npm module that is used to extend the behavior of a
Vagrantfile. It uses virtual machine definitions to spin up complete 
enviroments where you can run tests or run your code.

Installation
------------

```
npm install http://github.com/amatas/vagrant-vmenv
cp node_modules/vagrant-vmenv/Vagrantfile.sample Vagranfile
cp node_modules/vagrant-vmenv/qi.yml.sample .qi.yml
```

Working with vms
----------------

`vagrant up` to spin up the [default environment definition](envs/default.json)
`vagrant destroy` to stop and destroy the vm
`vagrant halt` to shutdown the vm

