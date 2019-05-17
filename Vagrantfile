# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
#

servers=[
  {
    :hostname => "ca",
    :ip => "192.168.100.24",
    :box => "bento/centos-7.3",
    :ram => 1024,
    :cpu => 1,
    :hport => 8095,
    :gport => 8080
  },
  {
    :hostname => "k8master",
    :ip => "192.168.100.14",
    :box => "bento/ubuntu-16.04",
    :ram => 1024,
    :cpu => 2,
    :hport => 8085,
    :gport => 8080
  },
  {
    :hostname => "k8node1",
    :ip => "192.168.100.15",
    :box => "bento/ubuntu-16.04",
    :ram => 1024,
    :cpu => 2,
    :hport => 8086,
    :gport => 8080
  },
  {
    :hostname => "k8node2",
    :ip => "192.168.100.16",
    :box => "bento/ubuntu-16.04",
    :ram => 1024,
    :cpu => 2,
    :hport => 8087,
    :gport => 8080
  },
  {
    :hostname => "ansible",
    :ip => "192.168.100.10",
    :box => "bento/centos-7.3",
    :ram => 1024,
    :cpu => 2,
    :hport => 8081,
    :gport => 8080
  },
  {
    :hostname => "gitlab",
    :ip => "192.168.100.11",
    :box => "bento/centos-7.3",
    :ram => 2048,
    :cpu => 2,
    :hport => 8082,
    :gport => 80
  },
  {
    :hostname => "gitlab11911",
    :ip => "192.168.100.26",
    :box => "bento/centos-7.3",
    :ram => 2048,
    :cpu => 2,
    :hport => 8097,
    :gport => 80
  },
  {
    :hostname => "nexus",
    :ip => "192.168.100.12",
    :box => "bento/centos-7.3",
    :ram => 2048,
    :cpu => 2,
    :hport => 8083,
    :gport => 8081
  },
  {
    :hostname => "winclient",
    :ip => "192.168.100.13",
    :box => "StefanScherer/windows_10",
    :ram => 2048,
    :cpu => 2,
    :hport => 8084,
     :gport => 8080
  },
  {
    :hostname => "linuxclient",
    :ip => "192.168.100.17",
    :box => "bento/centos-7.3",
    :ram => 1024,
    :cpu => 2,
    :hport => 8088,
    :gport => 8080
  },
  {
    :hostname => "gitlab-runner",
    :ip => "192.168.100.18",
    :box => "bento/centos-7.3",
    :ram => 1024,
    :cpu => 2,
    :hport => 8089,
    :gport => 8093
  },
  {
    :hostname => "jenkins",
    :ip => "192.168.100.19",
    :box => "bento/centos-7.3",
    :ram => 1024,
    :cpu => 2,
    :hport => 8090,
    :gport => 8080
  },
  {
    :hostname => "consul",
    :ip => "192.168.100.21",
    :ip2 => "192.168.100.22",
    :box => "bento/centos-7.3",
    :ram => 1024,
    :cpu => 2,
    :hport => 8092,
    :gport => 8500
  },
  {
    :hostname => "vault",
    :ip => "192.168.100.20",
    :box => "bento/centos-7.3",
    :ram => 1024,
    :cpu => 2,
    :hport => 8093,
    :gport => 8200
  },
  {
    :hostname => "vsphere",
    :ip => "192.168.100.23",
    :box => "vsphere",
    :ram => 4096,
    :cpu => 2,
    :hport => 8094,
    :gport => 8080
  },
  {
    :hostname => "PTFE",
    :ip => "192.168.100.25",
    :box => "bento/centos-7.3",
    :ram => 4096,
    :cpu => 2,
    :hport => 8096,
    :gport => 8800
  },
]


Vagrant.configure(2) do |config|
    servers.each do |machine|
        config.vm.define machine[:hostname] do |node|
            node.vm.box = machine[:box]
            node.vm.hostname = machine[:hostname]
            node.vm.network "private_network", ip: machine[:ip]
            if  machine[:ip2] != nil
              node.vm.network "private_network", ip: machine[:ip2]
            end
            node.vm.network "forwarded_port", host: machine[:hport], guest: machine[:gport]
              node.vm.provider "virtualbox" do |vb|
                vb.customize ["modifyvm", :id, "--memory", machine[:ram]]
                vb.customize ["modifyvm", :id, "--cpus", machine[:cpu]]
                if machine[:box] != "vsphere"
                  vb.customize ["storageattach", :id,
                  "--storagectl", "IDE Controller",
                  "--port", "0", "--device", "1",
                  "--type", "dvddrive",
                  "--medium", "emptydrive"]
                end
              end
            case machine[:box]
            when "StefanScherer/windows_10"
              node.vm.provision "shell",
              path: machine[:hostname] + ".ps1",
              powershell_elevated_interactive: "true",
              args: [ENV['DI2E_USERNAME'], ENV['DI2E_PASSWORD']]
            when "vsphere"
              node.vm.provision "shell",
              path: machine[:hostname] + ".sh",
              privileged: "false"
              node.ssh.shell = 'sh'
              node.ssh.insert_key = false
              node.vm.synced_folder '.', '/vagrant', disabled: true
            else
              node.vm.provision "shell",
              path: machine[:hostname] + ".sh",
              env: {"USERNAME"=>ENV['DI2E_USERNAME'], "PASSWORD"=>ENV['DI2E_PASSWORD']}
            end
        end
    end
end
