#!/bin/bash  
SUDO_FILE=/etc/sudoers.d/buildroot_conf
permission_grant()
{
	echo "User(${USER[@]}) is applying the sudo permission."
	file=$(tempfile)
        if [ "x$?" != "x0" ]
        then
                        echo "Failed to creat a tempfile.";
                        return 1
        fi
	
	if [ -f ${SUDO_FILE} ]
        then
                ${SUDO} rm -rf  ${SUDO_FILE} 
	fi
        echo "Host_Alias HOST = ${HOST}" >> ${file}
        echo "User_Alias USER = "${USER[0]} >> ${file}
        USER_RES=(${USER[@]})
        unset USER_RES[0]
        for u in "${USER_RES[@]}"
            do
                    ${SED} -i -e "/User_Alias/ s/$/,${u}/" ${file}
            done
        echo "Cmnd_Alias MOUNT    = ${MOUNT},${UMOUNT}" >> ${file}
        echo "Cmnd_Alias CHOWN = ${CHOWN}" >> ${file}
        echo "Cmnd_Alias CHROOT1 = ${CHROOT1}" >> ${file}
        echo "Cmnd_Alias CHMOD = ${CHMOD}" >> ${file}
	echo "Cmnd_Alias FIND = ${FIND}" >> ${file}
	echo "Cmnd_Alias CP = ${CP}" >> ${file}
	echo "Cmnd_Alias MV = ${MV}" >> ${file}
	echo "Cmnd_Alias DEBOOTSTRAP = ${DEBOOTSTRAP}" >> ${file}
	echo "Cmnd_Alias MKDIR = ${MKDIR}" >> ${file}
	echo "Cmnd_Alias TEE = ${TEE}" >> ${file}
	echo "Cmnd_Alias RM = ${RM}" >> ${file}
	echo "USER HOST=(root) NOPASSWD:MOUNT,CHMOD,CHROOT1,FIND,CP,MV,RM,MKDIR,TEE,CHOWN,DEBOOTSTRAP" >> ${file}
        ${SUDO} ${CHOWN} root:root ${file}
        ${SUDO} ${CHMOD} +r ${file}
        ${SUDO} ${MV} ${file} ${SUDO_FILE}
        echo "Buildroot User(${USER[@]}) is granted"
        return 0
}


HOST=ALL
SUDO=`which sudo`
MOUNT=`which mount`
UMOUNT=`which umount`
CHROOT1=`which chroot`
CHOWN=`which chown`
CHMOD=`which chmod`
FIND=`which find`
CP=`which cp`
MV=`which mv`
SED=`which sed`
MKDIR=`which mkdir`
TEE=`which tee`
RM=`which rm`
DEBOOTSTRAP=`which debootstrap`
if [ "x${DEBOOTSTRAP}" = "x" ]
then
        echo "debootstrap not found. Try running \"install debootstrap\""
        exit 1
fi
USER=()
confirmed=false

if [[ $# -eq 0 ]]
then
        USER=($(whoami))
fi

if [[ ${#USER[@]} -eq 0 ]]
then
        USER=($(whoami))
fi
permission_grant
