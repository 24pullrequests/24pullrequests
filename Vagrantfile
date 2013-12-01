# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "24pullrequests-20131130.box"

  config.vm.box_url = "https://s3.amazonaws.com/static.imatext.com/24pullrequests-20131130.box"

  config.vm.network :forwarded_port, guest: 3000, host: 3000

end
