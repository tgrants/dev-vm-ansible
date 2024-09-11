# PHP development VM configuration with ansible for students

## Instructions

* Configure VM:
	* Make sure the `hosts` file is configured correctly
	* Setup the VM `ansible-playbook playbooks/setup.yml`
* Trim virtual disk:
	* Remove all unnecessary files `ansible-playbook playbooks/cleanup.yml`
	* On VM:
		* `sudo dd if=/dev/zero of=/bigemptyfile bs=4096k status=progress`
		* `sudo rm -f /bigemptyfile`
	* On host:
		* `vboxmanage modifymedium /mnt/storage/VBOX/phpdev/phpdev.vdi --compact`
			* edit the path to match your .vdi file

## Other information

### Changelog

To see changes, see [Releases](https://github.com/tgrants/php-dev-vm-ansible/releases) in Github.

### License

This repository is licensed under the `Unlicense`. See LICENSE for more information.
