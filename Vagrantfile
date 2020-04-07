Vagrant.configure("2") do |config|
    config.vm.box = "debian/buster64"
    config.vm.provision :shell, :privileged => false, :path => "setup.sh"

    # Install xfce and virtualbox additions
    config.vm.provision "shell", inline: "sudo apt-get update"
    config.vm.provision "shell", inline: "sudo apt-get install -y xfce4 virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11"

    # Allow anyone to start the GUI
    config.vm.provision "shell", inline: "sudo sed -i 's/allowed_users=.*$/allowed_users=anybody/' /etc/X11/Xwrapper.config"

    # VM Specs
    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--cpus", "4"]
        vb.customize ["modifyvm", :id, "--memory", "4096"]
        vb.customize ["modifyvm", :id, "--vram", "256"]
    end

    config.ssh.username = 'vagrant'
    config.ssh.forward_agent = true
end
