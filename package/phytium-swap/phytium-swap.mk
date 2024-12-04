################################################################################
#
# phytium-swap
#
################################################################################

PHYTIUM_SWAP_VERSION = 0.1
PHYTIUM_SWAP_SITE = package/phytium-swap/src
PHYTIUM_SWAP_SITE_METHOD = local
PHYTIUM_SWAP_INSTALL_TARGET = YES

define  PHYTIUM_SWAP_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/phytium/
	$(INSTALL) -m 664 -D $(@D)/phytium-swap-user-config $(TARGET_DIR)/etc/default/
	$(INSTALL) -m 755 -D $(@D)/phytium-swap-config $(TARGET_DIR)/usr/lib/phytium/
	$(INSTALL) -m 644 -D $(@D)/phytium-swap-config.service $(TARGET_DIR)/lib/systemd/system/
endef

$(eval $(generic-package))
