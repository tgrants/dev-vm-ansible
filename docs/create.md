# Instructions for creating the VM

These instructions are for linux systems. Experimental.

## Host

- Download a Debian netinstall ISO. These instructions assume it is downloaded to `~/Downloads`.
- Install `xorriso` and `7zip`
- In the top level directory of this project, make a build directory `mkdir build && cd build`
- Copy (or move) the ISO to the newly created build directory `cp ~/Downloads/debian-* ./debian.iso`
- `mkdir iso_work`
- `7z x debian.iso -oiso_work`
- `mkdir initrd_tmp && cd initrd_tmp`
- `gzip -d < ../iso_work/install.amd/initrd.gz | cpio -idmv`
- `cp ../../preseed.cfg preseed.cfg`
- `find . | cpio -o -H newc | gzip -9 > ../iso_work/install.amd/initrd.gz`
- `cd ..`
- `rm -rf initrd_tmp`

```sh
xorriso -as mkisofs \
	-r -V "DEBIAN_AUTO" \
	-J -joliet-long \
	-b isolinux/isolinux.bin \
	-c isolinux/boot.cat \
	-no-emul-boot -boot-load-size 4 -boot-info-table \
	-eltorito-alt-boot \
	-e boot/grub/efi.img \
	-no-emul-boot -isohybrid-gpt-basdat \
	-o debian-preseed.iso \
	iso_work
```
