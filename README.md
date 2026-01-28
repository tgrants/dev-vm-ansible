# dev-vm-ansible

Automated development virtual machine setup for students using [Ansible](https://docs.ansible.com/).
Created to reduce the time spent in classrooms downloading and configuring virtual machines.

## Features

* ✅ **Lightweight** - Runs smoothly on modest hardware (tested with **2 GiB RAM**)
* ✅ **Compact** - Initial VirtualBox disk size: **<4 GiB** (<1 GiB compressed)
* ✅ **Preconfigured tools** - comes with development software and setup scripts to quickly install more

### Tools

| Category | Tools | Install scripts |
|---|---|---|
| **Editors** | [VSCode](https://code.visualstudio.com/), [VS Code Server](https://coder.com/docs/code-server) ||
| **Languages** | [PHP 8.4](https://www.php.net/), [Python 3.13](https://www.python.org/) | |
| **Databases** | [Sqlite3](https://sqlite.org/) | [MariaDB](https://mariadb.org/) |
| **Version Control** | [Git](https://git-scm.com/) | [GitHub CLI](https://cli.github.com/) |
| **Browsers** | [Firefox](https://www.firefox.com) | |
| **Dependency management** | [Composer](https://getcomposer.org/) | |

## Download

If you don't require a custom configuration, you can use one of these premade virtual machines.

> [!NOTE]
>
> It is recommended to use the latest available stable version.
> Older versions could be different - make sure you follow the corresponding version of the docs.

| Name | Size, GiB | Compressed, GiB | Date | Link |
|---|---|---|---|---|
| dvm_v7-dev.6.tar.xz | 3.36 | 0.69 | 2026-01-28 | [Google Drive](https://drive.google.com/file/d/1B4hdxRUkbK-PoF_Oh6nwZ6GeFu0MHeMK) |
| dvm_v7-dev.2.tar.xz | 2.97 | 0.67 | 2025-11-24 | [Google Drive](https://drive.google.com/file/d/1jvPNAQFk8HyuuMjYHMWpScZdtK9zUoYR) |
| dvm_v6.tar.xz | 3.66 | 0.86 | 2025-11-20 | [Google Drive](https://drive.google.com/file/d/1Rjvfs3aRKbXJhgDuVvdDD8T10-sTT2ju) |
| dvm_v6_preview.tar.xz | 3.90 | 1.02 | 2025-10-20 | [Google Drive](https://drive.google.com/file/d/1q-qfP15oDofYdsbwd0SO9UMu6PDzYbKI) |
| dvm_v5.tar.xz [1] | 4.12 | 1.15 | 2025-09-11 | [Google Drive](https://drive.google.com/file/d/1Z91MYWgvkLd0_oxOPxRJj9C7Ik0hEWZq) |
| dvm_v3.tar.xz [1][2] | 3.94 | 0.75 | 2024-09-28 | [Google Drive](https://drive.google.com/file/d/145d_nEzQ6dN0q9TqrJupR4yhy82o4wGR) |

[1] Virtual Disk Image only  
[2] Password is 'changeme'

### Similar projects

* [tgrants/dcm](https://github.com/tgrants/dcm) - development container manager

## Instructions

### Control machine

To run the playbook, you need to install Ansible on your control machine.

* [Arch linux](https://wiki.archlinux.org/title/Ansible)

### Virtualbox

#### Create the virtual machine

* Create a [Virtualbox](https://www.virtualbox.org/) VM
	* At least 2 GiB RAM is recommended for using an IDE and a browser at the same time
	* A 20 GB VDI disk should be enough, adjust for your requirements
* Install [Debian 13](https://www.debian.org/)
	* In the installer menu, press `TAB` and add `expert priority=low`
	* Choose language `en_US.UTF-8 locale`
	* Load installer components from installation media
	* Configure the network
		* Set the hostname e.g. *devvm*
	* Set up users and passwords
	* Set up users and passwords
		* Create a root user with password `pass`, allow login as root`
		* Create `user` with password `pass`
		* Alternatively, update [`hosts`](hosts) and [`vars.yml`](group_vars/all/vars.yml)
	* Configure the clock
	* Detect and partition disks
		* Select "Guided - use entire disk" and "All files in one partiton" for a simple setup
		* Manually create a single partition for a swapless setup
			* Partition table type - msdos
			* Use as: Ext4 journaling file system
			* Mount point: /
			* Bootable flag: on
	* Install the base system
		* Drivers to include in initrd: targeted
	* Configure the package manager
		* Use non-free software: yes (optional)
		* Enable source repositories in APT: no (optional)
	* Install the GRUB boot loader
	* Select and install software
		* Participate in the package usage survey: yes (optional)
		* In software selection, choose only `SSH server`, deselect everything else
	* Finish the installation
* Prepare the VM for Ansible (after booting it for the first time)
	* Log in as root
	* Update VM network settings in VirtualBox `Settings > Network > Attached to > Bridged Adapter`
	* Restart network service `systemctl restart networking`
	* Get the ip address with `ip a` and update [`hosts`](hosts) in this repository
	* Install sudo and python for Ansible `apt install sudo python3`
	* Add user to sudoers `adduser user sudo`
	* Copy key by SSH-ing into the VM from the control machine `ssh user@ip_address`
* Setup the VM
	* Copy and adjust the hosts file `cp hosts.example hosts`
		* Replace VM_IP_ADDRESS with the ip from the previous step
	* Edit files to customize your setup
		* [group_vars/](group_vars/) - basic settings
		* [roles/base/](roles/base/) - base packages and configuration, included scripts
		* [roles/dev/](roles/dev/) - development tool configuration
		* [roles/lxqt/](roles/lxqt/) - LXQt and GUI configuration
	* Run the setup playbook `ansible-playbook playbooks/setup.yml`
		* Some checks may throw an error when run for the first time
	* Reboot

#### Telemetry

Some data is collected to estimate the amount of premade VMs in use and their versions.
Telemetry settings are defined in [`dvm.conf`](roles/base/templates/dvm.conf.j2).
You can enable and disable this by running `dvmconf set combine enabled false` or editing the config manually.

The following data is collected: `public_ip`, `timestamp`, `id` and `version`.

#### Trim virtual disk

* Remove all unnecessary files `ansible-playbook playbooks/cleanup.yml`
* On VM, run `clear-disk`, then shut it down
* On host, run `vboxmanage modifymedium /mnt/storage/VBOX/dev_vm/dev_vm.vdi --compact`
	* Edit this path to match your .vdi file

## Updates

It is recommended to run new versions of these playbooks on a fresh Debian install.
Backwards compatibility with user-made tools is not guaranteed.

For details on changes, check the [Releases](https://github.com/tgrants/dev-vm-ansible/releases) page on GitHub.

## Contributing

Before submitting a pull request, please discuss your proposed changes in an issue first.
Feel free to open an issue if you encounter a problem or have any questions.

## License

This project is licensed under the terms of the [MIT license](https://choosealicense.com/licenses/mit/) (v4+).
See the [LICENSE](LICENSE) file for more information.
