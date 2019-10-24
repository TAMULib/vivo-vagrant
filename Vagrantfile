# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/ubuntu-18.04"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  config.vm.network "forwarded_port", guest: 80, host: 8081
  config.vm.network "forwarded_port", guest: 1066, host: 1066
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 8161, host: 8161
  config.vm.network "forwarded_port", guest: 8983, host: 8983
  config.vm.network "forwarded_port", guest: 61616, host: 61616

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "provision", "/home/vagrant/provision"
  config.vm.synced_folder "vivo-data", "/home/vagrant/vivo-data"
  config.vm.synced_folder "src", "/home/vagrant/src"
  config.vm.synced_folder "work", "/work"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
    # Customize number of CPUs on the VM:
    vb.cpus = 2
    # Customize the amount of memory on the VM:
    vb.memory = "8192"
  end

  config.vm.provider "vmware_fusion" do |v,override|
    v.gui = false
    v.vmx["numvcpus"] = "2"
    v.vmx["memsize"] = "8192"
  end

  config.vm.provider "hyperv" do |hv, override|
    hv.cpus = 2
    hv.memory = 8192
    override.vm.network :public_network, bridge: "Default Switch"
    override.vm.synced_folder ".", "/vagrant", type: "smb", mount_options: ["vers=3.02"], smb_host: ENV["HOST_IP"], smb_username: ENV["HOST_USERNAME"], smb_password: ENV["HOST_PASSWORD"]
    override.vm.synced_folder "provision", "/home/vagrant/provision", type: "smb", mount_options: ["vers=3.02"], smb_host: ENV["HOST_IP"], smb_username: ENV["HOST_USERNAME"], smb_password: ENV["HOST_PASSWORD"]
    override.vm.synced_folder "vivo-data", "/home/vagrant/vivo-data", type: "smb", mount_options: ["vers=3.02"], smb_host: ENV["HOST_IP"], smb_username: ENV["HOST_USERNAME"], smb_password: ENV["HOST_PASSWORD"]
    override.vm.synced_folder "src", "/home/vagrant/src", type: "smb", mount_options: ["vers=3.02"], smb_host: ENV["HOST_IP"], smb_username: ENV["HOST_USERNAME"], smb_password: ENV["HOST_PASSWORD"]
    override.vm.synced_folder "work", "/work", type: "smb", mount_options: ["vers=3.02"], smb_host: ENV["HOST_IP"], smb_username: ENV["HOST_USERNAME"], smb_password: ENV["HOST_PASSWORD"]
  end

  # Bootstrap
  config.vm.provision "bootstrap", type: "shell", path: "provision/bootstrap.sh", privileged: true

  # Install Tomcat
  config.vm.provision "tomcat", type: "shell", path: "provision/tomcat.sh", privileged: true

  # Install MySQL
  config.vm.provision "mysql", type: "shell", path: "provision/mysql.sh", privileged: true

  # Install Solr
  config.vm.provision "solr", type: "shell", path: "provision/solr.sh", privileged: true

  # Install Artemis
  config.vm.provision "artemis", type: "shell", path: "provision/artemis.sh", privileged: true

  # Install RDF Delta
  config.vm.provision "rdf_delta", type: "shell", path: "provision/rdf_delta.sh", privileged: true

  # Install VIVO
  config.vm.provision "vivo", type: "shell", path: "provision/install.sh", privileged: true

end
