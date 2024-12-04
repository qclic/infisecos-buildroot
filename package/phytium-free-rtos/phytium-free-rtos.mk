################################################################################
#
# phytium-free-rtos
#
################################################################################

PHYTIUM_FREE_RTOS_VERSION = v0.7.1
PHYTIUM_FREE_RTOS_SITE = https://gitee.com/phytium_embedded/phytium-free-rtos-sdk.git
PHYTIUM_FREE_RTOS_SITE_METHOD = git
PHYTIUM_FREE_RTOS_DEPENDENCIES = host-phytium-iot-environment host-python3 linux
PHYTIUM_FREE_RTOS_CPU = $(call qstrip,$(BR2_PACKAGE_PHYTIUM_FREE_RTOS_CPU_NAME))

define PHYTIUM_FREE_RTOS_CONFIGURE_CMDS
	cd $(@D) && \
	$(TARGET_MAKE_ENV) ./install.py
endef

define PHYTIUM_FREE_RTOS_BUILD_CMDS
	if [[ $(LINUX_VERSION_PROBED) = 5.10* ]]; then \
		PHYTIUM_FREE_RTOS_ARCH=aarch64; \
	else \
		PHYTIUM_FREE_RTOS_ARCH=aarch32; \
	fi && \
	. $(HOST_DIR)/etc/profile.d/phytium_dev.sh && \
	cd $(@D)/example/system/amp/openamp_for_linux && \
	$(TARGET_MAKE_ENV) $(MAKE1) config_$(PHYTIUM_FREE_RTOS_CPU)_$${PHYTIUM_FREE_RTOS_ARCH} && \
	mkdir -p $(TARGET_DIR)/lib/firmware && \
	$(TARGET_MAKE_ENV) $(MAKE1) image USR_BOOT_DIR=$(TARGET_DIR)/lib/firmware
endef

$(eval $(generic-package))
