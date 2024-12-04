################################################################################
#
# phytium-standalone
#
################################################################################

PHYTIUM_STANDALONE_VERSION = v1.2.3
PHYTIUM_STANDALONE_SITE = https://gitee.com/phytium_embedded/phytium-standalone-sdk.git
PHYTIUM_STANDALONE_SITE_METHOD = git
PHYTIUM_STANDALONE_DEPENDENCIES = host-phytium-iot-environment host-python3 linux
PHYTIUM_STANDALONE_CPU = $(call qstrip,$(BR2_PACKAGE_PHYTIUM_STANDALONE_CPU_NAME))

define PHYTIUM_STANDALONE_BUILD_CMDS
	if [[ $(LINUX_VERSION_PROBED) = 5.10* ]]; then \
		PHYTIUM_STANDALONE_ARCH=aarch64; \
	else \
		PHYTIUM_STANDALONE_ARCH=aarch32; \
	fi && \
	. $(HOST_DIR)/etc/profile.d/phytium_dev.sh && \
	cd $(@D)/example/system/amp/openamp_for_linux && \
	$(TARGET_MAKE_ENV) $(MAKE1) config_$(PHYTIUM_STANDALONE_CPU)_$${PHYTIUM_STANDALONE_ARCH} && \
	mkdir -p $(TARGET_DIR)/lib/firmware && \
	$(TARGET_MAKE_ENV) $(MAKE1) image USR_BOOT_DIR=$(TARGET_DIR)/lib/firmware
endef

$(eval $(generic-package))
