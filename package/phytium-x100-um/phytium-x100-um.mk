################################################################################
#
# phytium-x100-um
#
################################################################################

PHYTIUM_X100_UM_VERSION = x100-package-v1.0
PHYTIUM_X100_UM_SITE = https://gitee.com/phytium_embedded/phytium-rogue-umlibs.git
PHYTIUM_X100_UM_SITE_METHOD = git
PHYTIUM_X100_UM_INSTALL_STAGING = YES
PHYTIUM_X100_UM_PROVIDES = libegl libgles libgbm
define PHYTIUM_X100_UM_EXTRACT_DEB_PACKAGE
	(cd $(@D) && $(TARGET_AR) -x packages/DEBS/phytium-x100-gpu-drivers-um*.deb && \
	$(call suitable-extractor,data.tar.xz) data.tar.xz | \
		$(TAR) $(TAR_OPTIONS) -)
endef

PHYTIUM_X100_UM_POST_EXTRACT_HOOKS += PHYTIUM_X100_UM_EXTRACT_DEB_PACKAGE

ifeq ($(BR2_ROOTFS_SKELETON_CUSTOM),y)
define PHYTIUM_X100_UM_INSTALL_TARGET_CMDS
	cp -a $(@D)/etc/* $(TARGET_DIR)/etc
	cp -a $(@D)/usr/* $(TARGET_DIR)/usr
endef

define PHYTIUM_X100_UM_INSTALL_STAGING_CMDS
	cp -a $(@D)/etc/* $(STAGING_DIR)/etc
	cp -a $(@D)/usr/* $(STAGING_DIR)/usr
endef
endif

$(eval $(generic-package))
