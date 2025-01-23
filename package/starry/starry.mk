################################################################################
#
# StarryOS
#
################################################################################

STARRY_VERSION = aa6493b862be41b3c281d2b4345023eeba3109a4
STARRY_SITE = https://github.com/qclic/Starry.git
STARRY_SITE_METHOD = git
STARRY_LICENSE = MIT
STARRY_LICENSE_FILES = LICENSE.GPLv3
JAILHOUSE_DEPENDENCIES = jailhouse

ifeq ($(BR2_PACKAGE_STARRY_PLATFORM_PHYTIUMPI),y)
BR2_PACKAGE_STARRY_PLATFORM = aarch64-phytiumpi
else ifeq ($(BR2_PACKAGE_STARRY_PLATFORM_RASPBERRYPI4B),y)
BR2_PACKAGE_STARRY_PLATFORM = aarch64-raspi4
endif

BR2_PACKAGE_STARRY_EXAMPLE = monolithic_userboot

define STARRY_CONFIGURE_CMDS
	cp -f $(STARRY_PKGDIR)platforms/$(BR2_PACKAGE_STARRY_PLATFORM).toml $(@D)/platforms/
endef

define STARRY_BUILD_CMDS
	$(TARGET_MAKE_ENV) TARGET_DIR=$(@D)/target $(MAKE) -j1 -C $(@D) ARCH=$(BR2_ARCH) \
		PLATFORM=$(BR2_PACKAGE_STARRY_PLATFORM) A=apps/$(BR2_PACKAGE_STARRY_EXAMPLE) \
		FEATURES=img,ramdisk,ext4_rs
endef

define STARRY_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/apps/$(BR2_PACKAGE_STARRY_EXAMPLE)/*.bin \
		$(TARGET_DIR)/usr/local/libexec/jailhouse/demos/starry.bin
	$(INSTALL) -D -m 0644 $(@D)/disk.img \
		$(TARGET_DIR)/usr/local/libexec/jailhouse/demos/disk.img
endef

$(eval $(generic-package))