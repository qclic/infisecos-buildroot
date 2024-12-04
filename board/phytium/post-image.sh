#!/bin/sh

BOARD_DIR="$(dirname $0)"

cp -f ${BOARD_DIR}/grub.cfg ${BINARIES_DIR}/efi-part/EFI/BOOT/grub.cfg

if grep -Eq "^BR2_ROOTFS_INITRAMFS=y$" ${BR2_CONFIG} && grep -Eq "^BR2_ROOTFS_SKELETON_CUSTOM=y$" ${BR2_CONFIG}; then
	ROOTFS_DIR=${BINARIES_DIR}/rootfs
	sudo rm -rf ${ROOTFS_DIR}
	sudo mkdir -p ${ROOTFS_DIR}
	sudo tar xf ${BINARIES_DIR}/rootfs.tar -C ${ROOTFS_DIR}
	sudo cp ${ROOTFS_DIR}/usr/src/linux-headers-${KERNEL_VERSION}/.config ${ROOTFS_DIR}/boot/config-${KERNEL_VERSION}
	sudo sed -i 's/FSTYPE=auto/FSTYPE=ext4/g' ${ROOTFS_DIR}/etc/initramfs-tools/initramfs.conf
	sudo chroot ${ROOTFS_DIR} update-initramfs -c -k ${KERNEL_VERSION}
	sudo mv ${ROOTFS_DIR}/boot/initrd.img-${KERNEL_VERSION} ${BINARIES_DIR}/initrd.img
	sudo chown -R $USER:$GROUPS ${BINARIES_DIR}/initrd.img
	sudo rm -rf ${ROOTFS_DIR}
	if ! grep -q "initrd.img" $3; then
		sed -i '/files/a\
			"initrd.img",' $3
	fi
	sed -i '/linux/a\
	initrd /initrd.img' ${BINARIES_DIR}/efi-part/EFI/BOOT/grub.cfg
fi
