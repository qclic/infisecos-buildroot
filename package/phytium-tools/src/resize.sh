#!/bin/sh

# Phytium phytiumpi replace bootloader at runtime script
#
# Copyright (c) 2023-2024 Phytium Technology Co., Ltd.

ROOT_PART="$(findmnt / -o source -n)"
  ROOT_DEV="/dev/$(lsblk -no pkname "$ROOT_PART")"

  PART_NUM="$(echo "$ROOT_PART" | grep -o "[[:digit:]]*$")"
  
  LAST_PART_NUM=$(fdisk -l "$ROOT_DEV" | tail -n 1 | cut -f 1 -d' ' | cut -d 'p' -f 2)
  if [ "$LAST_PART_NUM" -ne "$PART_NUM" ]; then
    whiptail --msgbox "$ROOT_PART is not the last partition. Don't know how to expand" 20 60 2
    return 0
  fi

  # Get the starting offset of the root partition
  PART_START=$(fdisk -l "$ROOT_DEV" | tail -n 1 | cut -f 7 -d' ')
  [ "$PART_START" ] || return 1
  # Return value will likely be error for fdisk as it fails to reload the
  # partition table because the root fs is mounted
  fdisk "$ROOT_DEV" <<EOF
p
d
$PART_NUM
n
p
$PART_NUM
131072

p
w
EOF
resize2fs "$ROOT_PART" &&
printf "Please reboot\n"
