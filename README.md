# dev-vm-ansible

A compact [VirtualBox](https://www.virtualbox.org/) VM for students.
Automated with [Ansible](https://docs.ansible.com/).

## Motivation and philosophy

Virtual machines are a useful tool in classrooms, especially for software development since they provide a flexible, low-stakes learning environment.

However, in practice, there are several drawbacks:
- Downloading or transferring VMs over a network can put a heavy strain on it;
- A lot of space is taken up, especially if multiple students use the same computer;
- Precious instruction time is often lost to configuring and troubleshooting;

The philosophy of this project is to:
- Reduce the size of the VM while maintaining usabilty;
- Increase convenience with installation and configuration scripts;
- Stay close to a standard Debian system so users can benefit from existing online resources, while developers benefit from reduced maintenance costs;
- Follow best practices when possible.

## Features

- **Lightweight** - Runs smoothly on modest hardware (**1 GiB RAM**)
- **Compact** - Initial VirtualBox disk size: **~1.3 GiB** (~0.7 GiB compressed)
- **Preconfigured tools** - comes with development software and setup scripts to install more

### Default configuration

- Disk and filesystem
	- 20 GiB VDI, dynamically allocated
	- Initial size: ~1.3 GiB, 0.7 GiB compressed

### Tools

| Category | Tools | Install scripts |
|---|---|---|
| **Editors** | [VS Code Server](https://coder.com/docs/code-server) | |
| **Languages** | [PHP 8.4](https://www.php.net/), [Python 3.13](https://www.python.org/) | |
| **Databases** | [Sqlite3](https://sqlite.org/) | [MariaDB](https://mariadb.org/) |
| **Version Control** | [Git](https://git-scm.com/) | [GitHub CLI](https://cli.github.com/) |
| **Dependency management** | [Composer](https://getcomposer.org/) | |

### Requirements

> [!NOTE]
>
> These requirements apply to the latest release.

- Host
	- **OS**: [compatible with VirtualBox](https://www.virtualbox.org/wiki/Downloads)
	- **VirtualBox**: compatible with version 7.2
- VM
	- **vCPU**: 1 core is usually enough even with older CPUs.
	- **RAM**:  At least 512 MiB. 1 GiB is recommended.
	- **Storage**: at least 10 GiB is recommended.

## Download

If you don't require a custom configuration, you can use one of these prebuilt virtual machines.

> [!NOTE]
>
> It is recommended to use the latest available stable version.
> This documentation only applies to the latest release.
> See the history of this repository for previous documentation.

| Name | Size, GiB | Compressed, GiB | Date | Link |
|---|---|---|---|---|
| dvm_v8.tar.xz | 1.56 | 0.74 | 2026-08-06 | [Google Drive](https://drive.google.com/file/d/14PZ92j1gglvNOrsZVqpkGKqu-n8VSTPI) |
| dvm_v8-dev.12.tar.xz | 1.34 | 0.69 | 2026-06-30 | [Google Drive](https://drive.google.com/file/d/1CZMisYxZt_9_oDuumazdwpn0lADD5hSo) |
| dvm_v7.tar.xz [1] | 3.40 | 0.70 | 2026-02-07 | [Google Drive](https://drive.google.com/file/d/1mwLflrDo4P06W1H26qbXiJZv-2aSYssh) |
| dvm_v7-dev.6.tar.xz [1] | 3.36 | 0.69 | 2026-01-28 | [Google Drive](https://drive.google.com/file/d/1B4hdxRUkbK-PoF_Oh6nwZ6GeFu0MHeMK) |
| dvm_v7-dev.2.tar.xz [1] | 2.97 | 0.67 | 2025-11-24 | [Google Drive](https://drive.google.com/file/d/1jvPNAQFk8HyuuMjYHMWpScZdtK9zUoYR) |
| dvm_v6.tar.xz [1] | 3.66 | 0.86 | 2025-11-20 | [Google Drive](https://drive.google.com/file/d/1Rjvfs3aRKbXJhgDuVvdDD8T10-sTT2ju) |
| dvm_v6_preview.tar.xz [1] | 3.90 | 1.02 | 2025-10-20 | [Google Drive](https://drive.google.com/file/d/1q-qfP15oDofYdsbwd0SO9UMu6PDzYbKI) |
| dvm_v5.tar.xz [1][2] | 4.12 | 1.15 | 2025-09-11 | [Google Drive](https://drive.google.com/file/d/1Z91MYWgvkLd0_oxOPxRJj9C7Ik0hEWZq) |
| dvm_v3.tar.xz [2][3][4] | 3.94 | 0.75 | 2024-09-28 | [Google Drive](https://drive.google.com/file/d/145d_nEzQ6dN0q9TqrJupR4yhy82o4wGR) |

[1] Has a desktop environment: LXQt  
[2] Virtual Disk Image only  
[3] Has a desktop environment: Xfce  
[4] Password is 'changeme'

A complete list with releases and their checksums is available at [docs/releases.md](docs/releases.md).

### Similar projects

* [tgrants/dcm](https://github.com/tgrants/dcm) - development container manager

## Instructions

### Control machine

To run the playbook, you need to install Ansible on your control machine.

* [Arch linux](https://wiki.archlinux.org/title/Ansible)

### VirtualBox

#### Create the virtual machine

* Create a [VirtualBox](https://www.virtualbox.org/) VM
	* At least 1 GiB RAM is recommended
	* A 20 GB VDI disk should be enough, adjust for your requirements
	* Enable disk trimming `VBoxManage storageattach "dev_vm" --storagectl "SATA" --port 0 --device 0 --discard on`
* Install [Debian 13](https://www.debian.org/)
	* In the installer menu, press `TAB` and add `expert priority=low`
	* Choose language `en_US.UTF-8 locale`
	* Load installer components from installation media
	* Configure the network
		* Set the hostname, e.g. *dvm*
	* Set up users and passwords
		* Create a root user with password `pass`, allow login as root
		* Create `user` with password `pass`
		* Alternatively, update [`hosts`](hosts) and [`vars.yml`](group_vars/all/vars.yml)
	* Configure the clock
		* Select timezone: Coordinated Universal Time
	* Detect and partition disks
		* Select "Guided - use entire disk" and "All files in one partition" for a simple setup
		* Manually create a single partition for a swapless setup
			* Partition table type - msdos
			* Use as: btrfs journaling file system
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
	* Restart the network service `systemctl restart networking`
	* Get the IP address with `ip a` and update [`hosts`](hosts) in this repository
	* Install sudo and python for Ansible `apt install sudo python3`
	* Add user to sudoers `adduser user sudo`
	* Copy your SSH key by logging into the VM over SSH: `ssh user@ip_address`
		* Remember to exit before running commands on control machine
* Setup the VM
	* Copy and adjust the hosts file `cp hosts.example hosts`
		* Replace `VM_IP_ADDRESS` with the IP address from the previous step
	* Edit files to customize your setup
		* [group_vars/](group_vars/) - basic settings
		* [roles/base/](roles/base/) - base packages and configuration, included scripts
		* [roles/dev/](roles/dev/) - development tool configuration
		* [roles/lxqt/](roles/lxqt/) - LXQt and GUI configuration
	* Run the setup playbook `ansible-playbook playbooks/setup.yml`
		* Some checks may report errors the first time the playbook is run
	* Reboot

#### Telemetry

Some data is collected to estimate the amount of prebuilt VMs in use and their versions.
Telemetry settings are defined in [`dvm.conf`](roles/base/templates/dvm.conf.j2).
You can enable and disable this by running `dvmconf set combine enabled false` or editing the config manually.

The following data is collected: `public_ip`, `timestamp`, `id` and `version`.

#### Distribute the image

* On the VM, run `sudo sysprep`. This will prepare the system for distribution and shut it down. For more details, see [docs/sysprep.md](docs/sysprep.md).
* On the host, run `vboxmanage modifymedium /mnt/storage/VBOX/dev_vm/dev_vm.vdi --compact`
	* Edit this path to match your .vdi file

## Updates

It is recommended to run new versions of these playbooks on a fresh Debian installation.
Backwards compatibility with user-made tools is not guaranteed.

For details on changes, check the [Releases](https://github.com/tgrants/dev-vm-ansible/releases) page on GitHub.

## Contributing

Before contributing, please read our [Contribution guidelines](CONTRIBUTING.md).
Feel free to open an issue if you encounter a problem or have any questions.

## License

This project is licensed under the terms of the [MIT license](https://choosealicense.com/licenses/mit/) (v4+).
See the [LICENSE](LICENSE) file for more information.
