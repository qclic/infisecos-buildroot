################################################################################
#
# Phytium Pi uboot
#
################################################################################

PHYUBOOT_VERSION = 450cf1800670422e9a39b1589f2d1257ccb6ad24
PHYUBOOT_SITE = https://gitee.com/phytium_embedded/phytium-rogue-umlibs.git
PHYUBOOT_SITE_METHOD = git

PHYUBOOT_DEPENDENCIES = linux host-dtc
MKIMAGE_PI = $(HOST_DIR)/bin/mkimage_phypi
# The only available license files are in PDF and RTF formats, and we
# support only plain text.

PHYUBOOT_INSTALL_IMAGES = YES
PHYUBOOT_RAMSIZE = $(BR2_PACKAGE_PHYUBOOT_RAMSIZE)

define PHYUBOOT_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0777 $(@D)/phyuboot/fip-all-optee-$(BR2_PACKAGE_PHYUBOOT_RAMSIZE).bin $(BINARIES_DIR)/fip-all.bin
	$(INSTALL) -D -m 0777 $(PHYUBOOT_PKGDIR)/src/kernel.its $(BINARIES_DIR)/kernel.its
 	$(INSTALL) -D -m 755 $(PHYUBOOT_PKGDIR)/src/mkimage $(HOST_DIR)/bin/mkimage_phypi
	PATH=$(BR_PATH) $(MKIMAGE_PI) -f $(BINARIES_DIR)/kernel.its  $(BINARIES_DIR)/fitImage
endef

$(eval $(generic-package))
