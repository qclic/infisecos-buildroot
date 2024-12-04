################################################################################
#
# phytium-tools
#
################################################################################

PHYTIUM_TOOLS_VERSION = 0.1
PHYTIUM_TOOLS_SITE = package/phytium-tools/src
PHYTIUM_TOOLS_SITE_METHOD = local
PHYTIUM_TOOLS_INSTALL_TARGET_CMDS = YES

define  PHYTIUM_TOOLS_INSTALL_TARGET_CMDS
        mkdir -p $(TARGET_DIR)/usr/bin
	mkdir -p $(TARGET_DIR)/lib/firmware/rtlbt
	mkdir -p $(TARGET_DIR)/lib/systemd/system/
	mkdir -p $(TARGET_DIR)/lib/firmware/rtw88/
	mkdir -p $(TARGET_DIR)/lib/firmware/rtl_bt/
	mkdir -p $(TARGET_DIR)/etc/modprobe.d/
	$(INSTALL) -m 755 -D $(@D)/rtlbt/* $(TARGET_DIR)/lib/firmware/rtlbt/
	$(INSTALL) -m 755 -D $(@D)/rtk_hciattach $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 755 -D $(@D)/resize.sh  $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 644 -D $(@D)/systemd-hciattach.service $(TARGET_DIR)/lib/systemd/system/
	$(INSTALL) -m 755 -D $(@D)/runtime_replace_bootloader.sh $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 444 -D $(@D)/rtw8821c_fw.bin $(TARGET_DIR)/lib/firmware/rtw88/
	$(INSTALL) -m 755 -D $(@D)/rc.local $(TARGET_DIR)/etc/
	$(INSTALL) -m 755 -D $(@D)/rtlbt/rtl8821c_config $(TARGET_DIR)/lib/firmware/rtl_bt/rtl8821c_config.bin
	$(INSTALL) -m 755 -D $(@D)/rtlbt/rtl8821c_fw $(TARGET_DIR)/lib/firmware/rtl_bt/rtl8821c_fw.bin
	$(INSTALL) -m 755 -D $(@D)/rtw88.conf $(TARGET_DIR)/etc/modprobe.d/
endef

$(eval $(generic-package))
