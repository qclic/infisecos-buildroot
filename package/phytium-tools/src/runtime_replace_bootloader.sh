#!/bin/bash

# Phytium phytiumpi replace bootloader at runtime script
#
# Copyright (c) 2023-2024 Phytium Technology Co., Ltd.

#  runtime_replace_bootloader.sh - Providing the method for performing runtime replacement of the bootloader for phytiumpi.

usage()
{
	echo "Usage: sudo $0 [Option]"
	echo "  [Option] can be: "
	echo "			all: replace uboot+Image+dtb"
	echo "			uboot: replace uboot"
	echo " 			image: replace Image+dtb"
	echo "  For example: $0 all"
	echo "  Please make sure that the current directory contains fitImage or fip-all.bin that you want to replace."
}

while true; do
	case $1 in
	"-h")
		usage
		exit
		;;
	*)
		break
		;;
	esac
done

main()
{
	echo "-------------------------------$(date)-------------------------------" >> replace.log
	if [ "$1" == "all" ]; then
		#to preserve the partition table.
		dd if=/dev/mmcblk0 of=start.img bs=512 count=1 >> replace.log 2>&1
		dd if=fip-all.bin of=/dev/mmcblk0 bs=1M count=4 >> replace.log 2>&1
		dd if=start.img of=/dev/mmcblk0 bs=512 count=1 >> replace.log 2>&1
		dd if=fitImage of=/dev/mmcblk0 bs=1M seek=4 count=60 >> replace.log 2>&1
		rm -f start.img
	elif [ "$1" == "uboot" ]; then
		#to preserve the partition table.
		dd if=/dev/mmcblk0 of=start.img bs=512 count=1 >> replace.log 2>&1
		dd if=fip-all.bin of=/dev/mmcblk0 bs=1M count=4 >> replace.log 2>&1
		dd if=start.img of=/dev/mmcblk0 bs=512 count=1 >> replace.log 2>&1
		rm -f start.img
	elif [ "$1" == "image" ]; then
		dd if=fitImage of=/dev/mmcblk0 bs=1M seek=4 count=60 >> replace.log 2>&1
	else
		echo "args error, exit"
	fi
	
	if [ "$?" != "0" ]; then
		echo "dd to /dev/mmcblk0 failed"
		exit 1
	fi
	echo "--------------------------------------------------------------------------" >> replace.log
}

main $@
