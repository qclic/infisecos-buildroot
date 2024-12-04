#!/usr/bin/env bash

deploy_kernel_headers_510 () {
	topdir=$(pwd)
	pdir=$1
	version=$2
	srctree=$pdir/lib/modules/$version/source
	objtree=$pdir/lib/modules/$version/build
	cd $objtree
	mkdir debian

	(
		cd $srctree
		find . arch/arm64 -maxdepth 1 -name Makefile\*
		find include scripts -type f -o -type l
		find arch/arm64 -name Kbuild.platforms -o -name Platform
		find $(find arch/arm64 -name include -o -name scripts -type d) -type f
	) > debian/hdrsrcfiles

	{
		if grep -q "^CONFIG_STACK_VALIDATION=y" include/config/auto.conf; then
			echo tools/objtool/objtool
		fi

		find arch/arm64/include Module.symvers include scripts -type f

		if grep -q "^CONFIG_GCC_PLUGINS=y" include/config/auto.conf; then
			find scripts/gcc-plugins -name \*.so
		fi
	} > debian/hdrobjfiles

	destdir=$pdir/usr/src/linux-headers-$version
	mkdir -p $destdir
	tar -c -f - -C $srctree -T debian/hdrsrcfiles | tar -xf - -C $destdir
	tar -c -f - -T debian/hdrobjfiles | tar -xf - -C $destdir
	rm -rf debian

	# copy .config manually to be where it's expected to be
	cp .config $destdir/.config
	# used to build dma
	cp drivers/dma/dmaengine.h $1/usr/include
	cp drivers/dma/virt-dma.h $1/usr/include
	find $destdir -name "*.o" -type f -exec rm -rf {} \;
	cd $topdir
	cp -r board/phytium/common/linux-5.10/scripts $destdir

	rm -rf $srctree
	rm -rf $objtree
	ln -s /usr/src/linux-headers-$version $pdir/lib/modules/$version/build
}

deploy_kernel_headers_419 () {
	topdir=$(pwd)
	pdir=$1
	version=$2
	srctree=$pdir/lib/modules/$version/source
	objtree=$pdir/lib/modules/$version/build
	cd $objtree
	mkdir debian

	(cd $srctree; find . -name Makefile\* -o -name Kconfig\* -o -name \*.pl) > "$objtree/debian/hdrsrcfiles"
	(cd $srctree; find arch/*/include include scripts -type f -o -type l) >> "$objtree/debian/hdrsrcfiles"
	(cd $srctree; find arch/arm64 -name module.lds -o -name Kbuild.platforms -o -name Platform) >> "$objtree/debian/hdrsrcfiles"
	(cd $srctree; find $(find arch/arm64 -name include -o -name scripts -type d) -type f) >> "$objtree/debian/hdrsrcfiles"
	if grep -q '^CONFIG_STACK_VALIDATION=y' .config ; then
		(cd $objtree; find tools/objtool -type f -executable) >> "$objtree/debian/hdrobjfiles"
	fi
	(cd $objtree; find arch/arm64/include Module.symvers include scripts -type f) >> "$objtree/debian/hdrobjfiles"
	if grep -q '^CONFIG_GCC_PLUGINS=y' .config ; then
		(cd $objtree; find scripts/gcc-plugins -name \*.so -o -name gcc-common.h) >> "$objtree/debian/hdrobjfiles"
	fi
	destdir=$pdir/usr/src/linux-headers-$version
	mkdir -p "$destdir"
	(cd $srctree; tar -c -f - -T -) < "$objtree/debian/hdrsrcfiles" | (cd $destdir; tar -xf -)
	(cd $objtree; tar -c -f - -T -) < "$objtree/debian/hdrobjfiles" | (cd $destdir; tar -xf -)
	(cd $objtree; cp .config $destdir/.config) # copy .config manually to be where it's expected to be
	(cd $srctree; cp --parents tools/include/tools/be_byteshift.h $destdir)
	(cd $srctree; cp --parents tools/include/tools/le_byteshift.h $destdir)
	(cd $srctree; cp drivers/dma/dmaengine.h $1/usr/include) # used to build dma
	(cd $srctree; cp drivers/dma/virt-dma.h $1/usr/include)
	find $destdir -name "*.o" -type f -exec rm -rf {} \;
	cd $topdir
	cp -r board/phytium/common/linux-4.19/scripts $destdir
	rm -rf "$objtree/debian"

	rm -rf $srctree
	rm -rf $objtree
	ln -sf "/usr/src/linux-headers-$version" "$pdir/lib/modules/$version/build"
}

main()
{
	# $1 - the current rootfs directory, skeleton-custom or target

	if [ ! -d $1/lib/modules ]; then
		make linux-rebuild ${O:+O=$O}
	fi

	KERNELVERSION=`ls $1/lib/modules`
	if grep -Eq "^BR2_ROOTFS_LINUX_HEADERS=y$" ${BR2_CONFIG} && [ -L $1/lib/modules/${KERNELVERSION}/source ]; then
		if [[ ${KERNELVERSION} = 5.10* || ${KERNELVERSION} = 5.15* ]];then
			deploy_kernel_headers_510 $1 ${KERNELVERSION}
		elif [[ ${KERNELVERSION} = 4.19* ]];then
			deploy_kernel_headers_419 $1 ${KERNELVERSION}
		else
			echo "error: linux kernel version is not 4.19, 5.10, or 5.15."
		fi
	fi

	if grep -Eq "^BR2_PACKAGE_PHYTIUM_OPTEE=y$" ${BR2_CONFIG}; then
		# add tee-supplicant systemd service
		cp -dpf package/phytium-optee/phytium-tee-supplicant.service $1/lib/systemd/system/phytium-tee-supplicant.service
		# default set start tee-supplicant
		ln -sf /lib/systemd/system/phytium-tee-supplicant.service $1/etc/systemd/system/sysinit.target.wants/phytium-tee-supplicant.service
	fi

	# swap
        if grep -Eq "^BR2_PACKAGE_PHYTIUM_SWAP=y$" ${BR2_CONFIG}; then
        	sudo chroot ${1} systemctl enable phytium-swap-config.service
	fi

	exit $?
}

main $@
