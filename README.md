Vagrant-vmenv
=============

Vagrant-vmenv is a npm module that is used to extend the behavior of a
Vagrantfile. It uses virtual machine definitions to spin up complete 
enviroments where you can run tests or run your code.

Installation
------------

```
npm install http://github.com/amatas/vagrant-vmenv
cp node_modules/vagrant-vmenv/Vagrantfile.template Vagranfile
cp node_modules/vagrant-vmenv/qi.yml.template .qi.yml
```

Working with vms
----------------

`vagrant up` to spin up the [default environment definition](envs/default.json)
`vagrant destroy` to stop and destroy the vm
`vagrant halt` to shutdown the vm

Networking
----------

A VM can have multiple virtual NICs. Two types are avilable for each NIC: public
and private. The public NICs will be attached to the host's physical network,
the private NICs will be attached to a private network only visible between the
other VMs and the host. The IP address of a private network can be customized in
the definition of the VM. An example of the network definition of a VM can be:

```
networks:
  privatenet:
    type: private
    ip: 192.168.45.22
  publicnet:
    type: public
```

If an environment has multiple VMs definitions with several NICs the _hosts_
file of each VM will list all the IP address of each VM plus the name of the VM,
this is very useful to point services between the VMs.

Forwarded ports
---------------

TODO

Shared folders
--------------

Each application can use a shared folder. If the _folder_ variable of the
application has a _src_ key, Vagrant will map the path set in the src folder of
the host to the path set in the _dest_ variable in the VM.

```
folder:
  src: "."
  dest: "/app/universal"
```

More samples definitions can be found either in the [envs](envs) directory or in
the [qi.yml.sample](qi.yml.sample).
