################################################################################
#
# XORG-firmware
#
################################################################################

XORG_ROGUE_UMLIBS_VERSION = 4f42d33527728c294662010908187c04fac320ea
XORG_ROGUE_UMLIBS_CUSTOM_REPO_URL = https://gitee.com/phytium_embedded/phytium-rogue-umlibs.git
XORG_ROGUE_UMLIBS_SITE = $(call qstrip,$(XORG_ROGUE_UMLIBS_CUSTOM_REPO_URL))
XORG_ROGUE_UMLIBS_SITE_METHOD = git
XORG_ROGUE_UMLIBS_INSTALL_STAGING = YES
XORG_ROGUE_UMLIBS_PROVIDES = libegl libgles libgbm

define XORG_ROGUE_UMLIBS_BUILD_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) all
endef

ifeq ($(BR2_PACKAGE_XORG_ROGUE_UMLIBS_FIRMWARE),y)
define XORG_ROGUE_UMLIBS_INSTALL_TARGET_CMDS
	cp -a $(@D)/targetfs/phytium-linux/xorg/lib/firmware $(TARGET_DIR)/lib
endef
else
define XORG_ROGUE_UMLIBS_INSTALL_TARGET_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install DESTDIR=$(TARGET_DIR) WINDOW_SYSTEM=xorg
endef
endif

define XORG_ROGUE_UMLIBS_INSTALL_STAGING_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install DESTDIR=$(STAGING_DIR) WINDOW_SYSTEM=xorg
endef

$(eval $(generic-package))
