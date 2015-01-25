# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.env.enable

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "cros-up"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb, override|
     #vb.gui = true
     vb.customize ["modifyvm", :id, "--memory", "4096"]
     vb.cpus = 2
     if ENV.has_key?('USB_ATTACH')
       vb.customize ["modifyvm", :id, "--usb", "on"]
       vb.customize ["modifyvm", :id, "--usbehci", "on"]
       ENV['USB_ATTACH'].split() do |current_device|
         vb.customize ["usbfilter", "add", "0",
                       "--target", :id,
                       "--name", "Flash Target",
                       "--serialnumber", ENV['USB_ATTACH'] ]
       end
     end
     if ENV.has_key?('PUBLIC_IP') and ENV['PUBLIC_IP'] == 'DHCP'
       override.vm.network "public_network"
     elsif ENV.has_key?('PUBLIC_IP')
       override.vm.network "public_network", ip: ENV['PUBLIC_IP']
     end
  end

  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = ENV['DO_SSH_KEY'] || "~/.ssh/id_rsa.do_vagrant"
    override.vm.box = "digital_ocean"
    override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    override.vm.box_download_checksum = "abc86ce78b6990fc0805adaf4cf7e82e3945c455781ae30614bf359210a48578"
    override.vm.box_download_checksum_type = "sha256"

    provider.token = ENV['DO_TOKEN']
    provider.image = 'ubuntu-14-04-x64'
    provider.region = 'nyc3'
    provider.size = '2gb'
    provider.private_networking = true
    provider.backups_enabled = false
  end

  config.vm.synced_folder "salt/states", "/srv/salt/states"

  config.vm.provision :salt do |salt|
    salt.minion_config = "salt/minion"

    salt.pillar({
                  "git" => {
                      "name" => ENV['GIT_NAME'] || "Unknown",
                      "email" => ENV['GIT_EMAIL'] || "fixme@example.com"
                  },
                  "build_user" => ENV['BUILD_USER'] || "crosupuser",
                  "image_flags" => ENV['IMAGE_FLAGS'] || "--noenable_rootfs_verification dev",
                  "board_list" => ENV['BOARD_LIST'] || "",
                  "resync_sources" => ENV['RESYNC_SOURCES'] || "0",
                  "nfs_export" => ENV['NFS_EXPORT'] || ""
                })
    salt.run_highstate = true
  end

end
