# dev-vm-ansible

Automated development virtual machine setup for students using [Ansible](https://docs.ansible.com/).
Created to reduce the time spent in classrooms downloading and configuring virtual machines.

## Features

* ✅ **Lightweight** - Runs smoothly on modest hardware (tested with **2 GiB RAM**)
* ✅ **Compact** - Initial VirtualBox disk size: **~4 GiB** (~1 GiB when compressed)
* ✅ **Preconfigured tools** - comes with development software and setup scripts to quickly install more
* 🟡 **Telemetry** (opt-out, planned)

### Tools

* [PHP](https://www.php.net/) and [Composer](https://getcomposer.org/)
* [Python](https://www.python.org/)
* [Sqlite3](https://sqlite.org/)
* [VSCode](https://code.visualstudio.com/)
* [Git](https://git-scm.com/)
* [Firefox](https://www.firefox.com)

### Install scripts

* [MariaDB](https://mariadb.org/)
* [GitHub CLI](https://cli.github.com/)

## Download

If you don't require a custom configuration, you can use one of these virtual machines.

| Name | Size, GiB | Size (compressed), GiB | Date | Link |
|---|---|---|---|---|
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

* Arch linux: `sudo pacman -S ansible`

### Virtualbox

#### Create the virtual machine

* Create a [Virtualbox](https://www.virtualbox.org/) VM
	* At least 2 GiB RAM is recommended for using an IDE and a browser at the same time
	* A 20 GB VDI disk should be enough, adjust for your requirements
* Install [Debian 13](https://www.debian.org/)
	* Select `en_US.UTF-8 locale`
	* Set the hostname e.g. *devvm*
	* Create users (or update [`hosts`](hosts))
		* Set root password to `pass`
		* Create `user` with password `pass`
	* Partition disks
		* Select "Guided - use entire disk" and "All files in one partiton" for a simple setup
		* Manually create a single bootable ext4 partition for a swapless setup
	* Software selection - select only `SSH server`, deselect everything else
* Prepare the VM for Ansible (after booting it for the first time)
	* Update VM network settings in VirtualBox `Settings > Network > Attached to > Bridged Adapter`
	* Log in as root `su -`
	* Restart network service `systemctl restart networking`
	* Get the ip address with `ip a` and update [`hosts`](hosts) in this repository
	* Install sudo and python for Ansible `apt install sudo python3`
	* Add user to sudoers `adduser user sudo`
	* Copy key by SSH-ing into the VM `ssh user@192.168.x.y`
* Setup the VM
	* Copy and adjust the hosts file `cp hosts.example hosts`
		* Replace VM_IP_ADDRESS with the ip from the previous step
	* Edit files to customize your setup
		* [group_vars/](group_vars/) - basic settings
		* [roles/base/](roles/base/) - base packages and configuration, included scripts
		* [roles/dev/](roles/dev/) - development tool configuration
		* [roles/lxqt/](roles/lxqt/) - LXQt and GUI configuration
	* Run the setup playbook `ansible-playbook playbooks/setup.yml`

#### Telemetry

* Add telemetry `ansible-playbook playbooks/telemetry.yml`

#### Trim virtual disk

* Remove all unnecessary files `ansible-playbook playbooks/cleanup.yml`
* On VM, run `clear-tmp` and `clear-disk`, then shut it down
* On host, run `vboxmanage modifymedium /mnt/storage/VBOX/dev_vm/dev_vm.vdi --compact`
	* Edit this path to match your .vdi file

## Updates

It is recommended to run new versions of these playbooks on a fresh Debian install.
Re-running them should work most of the time, but may occasionally cause issues.

For details on changes, check the [Releases](https://github.com/tgrants/dev-vm-ansible/releases) page on GitHub.

## Contributing

Before submitting a pull request, please discuss your proposed changes in an issue first.
Feel free to open an issue if you encounter a problem or have any questions.

## License

> [!NOTE]
>
> Versions below `v4` are licensed under the terms of the [Unlicense](https://choosealicense.com/licenses/unlicense/).

This project is licensed under the terms of the [MIT license](https://choosealicense.com/licenses/mit/).
See the [LICENSE](LICENSE) file for more information.
