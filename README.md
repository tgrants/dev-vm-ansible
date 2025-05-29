# dev-vm-ansible

Automated development virtual machine setup for students using [Ansible](https://docs.ansible.com/).

## Features

* ✅ **Lightweight** - Runs smoothly on modest hardware (tested with **2 GiB RAM**)
* ✅ **Compact** - Initial VirtualBox disk size: **~4 GiB** (~1 GiB when compressed)
* ✅ **Preconfigured tools** - comes with development software and setup scripts
* 🟡 **Custom xfce theme** (planned)
* 🟡 **Telemetry** (opt-out, planned)

### Tools

* PHP and Composer
* Sqlite3
* VSCode and Git

### Install scripts

* Node.js and npm
* MariaDB
* Github cli

## Instructions

### Virtualbox

#### Create the virtual machine

* Install [Debian](https://www.debian.org/) on a [Virtualbox](https://www.virtualbox.org/) VM
	* Create users (or update `hosts`)
		* Set root password to `pass`
		* Create `user` with password `pass`
	* Software selection - select only `SSH server`
* Prepare the VM for ansible
	* Update VM network settings in VirtualBox `Settings > Network > Attached to > Bridged Adapter`
	* Log in as root `su -`
	* Restart network service `systemctl restart networking`
	* Get the ip address with `ip a` and update the `hosts` in this repository
	* Install sudo and python for Ansible `apt install sudo python3`
	* Add user to sudoers `adduser user sudo`
	* Copy key by SSH-ing into the VM `ssh user@192.168.x.y`
* Setup the VM `ansible-playbook playbooks/setup.yml`

#### Trim virtual disk

* Remove all unnecessary files `ansible-playbook playbooks/cleanup.yml`
* On VM, run `clear-disk`, then shut it down
* On host, run `vboxmanage modifymedium /mnt/storage/VBOX/phpdev/phpdev.vdi --compact`
	* Edit this path to match your .vdi file

## Updates

It is recommended to run new versions of these playbooks on a fresh Debian install.
However, in most cases, re-running them should work without issues.

For details on changes, check the [Releases](https://github.com/tgrants/dev-vm-ansible/releases) page on GitHub.

## Contributing

Before submitting a pull request, please discuss your proposed changes in an issue first.
Major changes are generally not accepted, as this project is customized for my requirements.
For such changes it is recommended to create your own fork of this project.
However, feel free to open an issue if you encounter a problem or have any questions.

## License

> [!NOTE]
>
> Versions below `v4` are licensed under the terms of the [Unlicense](https://choosealicense.com/licenses/unlicense/).

This project is licensed under the terms of the [MIT license](https://choosealicense.com/licenses/mit/).
See the [LICENSE](LICENSE) file for more information.
