# PHP development VM configuration with ansible for students

## Features

* Lightweight
	* uses Xfce
	* ~4 GiB initial virtual disk size with VirtualBox
	* RAM >= 2 GiB
* Includes
	* Various tools
		* PHP and Composer
		* Sqlite3
		* VSCode and Git
	* Install scripts
		* Node.js and npm
		* MariaDB

## Instructions

* Create the virtual machine:
	* Install [Debian](https://www.debian.org/) on a [Virtualbox](https://www.virtualbox.org/) VM
		* Create users (or update `hosts`)
			* Set root password to `changeme`
			* Create `user` with password `changeme`
		* Software selection - select only `SSH server`
	* Prepare the VM for ansible
		* Make sure you can ssh into the VM
			* Update VM network settings `Machine > Settings > Network > Attached to > Bridged Adapter`
			* Get the ip address with `ip a` and update `hosts`
			* Copy key by SSH-ing into the VM `ssh user@192.168.x.y`
		* Install packages and add sudo privileges to user
			* Log in as root with `su -` and install packages `apt install sudo python3`
			* Add user to sudoers `adduser user sudo`
	* Setup the VM `ansible-playbook playbooks/setup.yml`
* Trim virtual disk:
	* Remove all unnecessary files `ansible-playbook playbooks/cleanup.yml`
	* On VM:
		* `sudo dd if=/dev/zero of=/bigemptyfile bs=4096k status=progress`
		* `sudo rm -f /bigemptyfile`
	* On host:
		* `vboxmanage modifymedium /mnt/storage/VBOX/phpdev/phpdev.vdi --compact`
			* Edit this path to match your .vdi file

## Other information

### Updates

It is recommended to create a new install every time you run a new version of these playbooks.

To see changes, see [Releases](https://github.com/tgrants/php-dev-vm-ansible/releases) in Github.

### License

This repository is licensed under `The Unlicense`. See `LICENSE` for more information.
