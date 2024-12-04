################################################################################
#
# phytium-iot-environment
#
################################################################################

# source included in the package
HOST_PHYTIUM_IOT_ENVIRONMENT_DEPENDENCIES = host-arm-gnu-a-toolchain host-aarch64-none-elf-toolchain

define HOST_PHYTIUM_IOT_ENVIRONMENT_EXTRACT_CMDS
	cp $(HOST_PHYTIUM_IOT_ENVIRONMENT_PKGDIR)/phytium_dev.sh $(@D)
endef

define HOST_PHYTIUM_IOT_ENVIRONMENT_INSTALL_CMDS
	mkdir -p $(HOST_DIR)/etc/profile.d
	$(INSTALL) -D -m 0755 $(@D)/phytium_dev.sh $(HOST_DIR)/etc/profile.d
endef

$(eval $(host-generic-package))
