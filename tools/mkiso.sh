#!/usr/bin/env bash
# This script creates a preseeded debian ISO
#
# (c) Toms Grants, MIT License
# {{ source_url }}
#
# Last updated: 2026-09-24

set -euo pipefail

# Check if run in the correct directory
if [[ "$(basename "$PWD")" != "dev-vm-ansible" ]]; then
  echo "Error: This script must be run inside the 'dev-vm-ansible' project directory." >&2
  exit 1
fi

# Ensure necessary directories exist
mkdir -p build/iso_work build/initrd_tmp

# Extract debian iso
7z x debian.iso -obuild/iso_work

# Customize inirtd
cd build/initrd_tmp
gzip -d < ../iso_work/install.amd/initrd.gz | cpio -idmv
cp ../../preseed.cfg preseed.cfg
find . | cpio -o -H newc | gzip -9 > ../iso_work/install.amd/initrd.gz
cd ../..

# Build debian ISO
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
  build/iso_work
