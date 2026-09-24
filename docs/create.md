# Instructions for creating the VM

These instructions are for linux systems.

If you are using Windows or any other operating system that does not have the
necessary tools, you can build the VM inside dvm virtual machine.

## Host

### Create the ISO

- Download a Debian netinstall ISO and copy it to the top level directory of the
  project
  - For example, `cp ~/Downloads/debian-* ./debian.iso`
- Install `xorriso` and `7zip`
- Check if `build/` directory exists. If it does, remove it `rm -r build/`
- In the top level directory of this project, run `tools/mkiso.sh`
  - A `debian-preseed.iso` should be created

<!--
### Create and configure the VM

### Apply playbooks
-->
