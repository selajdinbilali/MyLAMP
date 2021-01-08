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
  config.vm.box = "ubuntu/bionic64"
  # install : vagrant plugin install vagrant-disksize
  config.disksize.size = '25GB'

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "./sites", "/var/www/html", owner: "vagrant", group:"www-data", mount_options: ["dmode=775,fmode=664"]
  config.vm.synced_folder "./scripts", "/home/vagrant/scripts", owner: "vagrant", group:"vagrant", mount_options: ["dmode=775,fmode=664"]
  


  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
  
    # Customize the amount of memory on the VM:
    vb.memory = "2048"
    vb.cpus = 1
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    echo "Hello, welcome to LAMP install for ubuntu 20.04 in virtualbox vm with vagrant and + phpmyadmin"
    apt-get update
	apt-get install -y debconf-utils
    apt-get install -y apache2
	ufw allow in "Apache"
	
    echo "installing mysql root:root no mysql_secure_installation for now"
	# Install MySQL Server in a Non-Interactive mode. Default root password will be "root"
	echo "mysql-server mysql-server/root_password password root" | sudo debconf-set-selections
	echo "mysql-server mysql-server/root_password_again password root" | sudo debconf-set-selections
	apt-get -y install mysql-server

	echo "installing php with libapache mysql and sqlite3 modules"
	apt-get install -y php libapache2-mod-php php-mysql php-sqlite3
	
	echo "phpmyadmin phpmyadmin/internal/skip-preseed boolean true" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect" | debconf-set-selections
	echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
	
    echo "installing php my admin"
	apt-get install -y phpmyadmin php-mbstring php-gettext
	ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
    a2enconf phpmyadmin.conf
    #echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf
	
    echo "installing php modules for laravel"
    apt-get install -y php-common php-cli php-gd php-mysql php-curl php-intl php-mbstring php-bcmath php-imap php-xml php-zip
    add-apt-repository ppa:ondrej/php
    apt-get update
    apt-get install -y apache2 libapache2-mod-php php php-xml php-gd php-opcache php-mbstring php-curl


	apt-get install -y composer
	
	sudo fallocate -l 4G /swapfile
	sudo chmod 600 /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile
	echo '\n/swapfile   none    swap    sw    0   0' >> /etc/fstab
	
    sudo a2enmod rewrite
	systemctl restart apache2
 

  ## dans php ini 
  ## upload_max_filesize
  ## display_errors=On
  ## errors_login all
  ## composer install
  PHPV=$(php -v | grep "PHP 7" | cut -c5-7)
  echo 'display_errors=On' >> /etc/php/$PHPV/apache2/php.ini
  echo 'upload_max_filesize=20M' >> /etc/php/$PHPV/apache2/php.ini
  echo 'display_startup_errors = On' >> /etc/php/$PHPV/apache2/php.ini
  echo 'error_reporting=E_ALL' >> /etc/php/$PHPV/apache2/php.ini
  SHELL
end
