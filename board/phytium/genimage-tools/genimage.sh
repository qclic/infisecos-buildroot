#!/usr/bin/env bash

die() {
  cat <<EOF >&2
Error: $@

Usage: ${0} -c GENIMAGE_CONFIG_FILE
EOF
  exit 1
}

# Parse arguments and put into argument list of the script
opts="$(getopt -n "${0##*/}" -o c:d: -- "$@")" || exit $?
eval set -- "$opts"

while true ; do
	case "$1" in
	-c)
	  GENIMAGE_CFG="${2}";
	  shift 2 ;;
	-d)
	  DTB="${2}";
	  shift 2 ;;
	--) # Discard all non-option parameters
	  shift 1;
	  break ;;
	*)
	  die "unknown option '${1}'" ;;
	esac
done

[ -n "${GENIMAGE_CFG}" ] || die "Missing argument"

WORKDIR=$(dirname $(readlink -f "$0"))
export PATH=${WORKDIR}:$PATH
ROOTPATH=${ROOTPATH-${WORKDIR}/root}
GENIMAGE_TMP=${GENIMAGE_TMP-${WORKDIR}/genimage.tmp}
INPUTPATH=${INPUTPATH-${WORKDIR}/input}
OUTPUTPATH=${OUTPUTPATH-${WORKDIR}/images}

# sd image
if grep -q "fitImage" ${GENIMAGE_CFG}; then
	if [ ! -e ${INPUTPATH}/Image.gz ]; then
		cat ${INPUTPATH}/Image | gzip -n -f -9 > ${INPUTPATH}/Image.gz
	fi
	cp ${WORKDIR}/kernel.its ${INPUTPATH}/kernel.its
	sed -i "s/phytiumpi_firefly.dtb/${DTB}/g" ${INPUTPATH}/kernel.its
	mkimage_phypi -f ${INPUTPATH}/kernel.its ${INPUTPATH}/fitImage
fi

rm -rf "${GENIMAGE_TMP}"

trap 'rm -rf "${GENIMAGE_TMP}"' EXIT

genimage \
	--rootpath "${ROOTPATH}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${INPUTPATH}"  \
	--outputpath "${OUTPUTPATH}" \
	--config "${GENIMAGE_CFG}"
