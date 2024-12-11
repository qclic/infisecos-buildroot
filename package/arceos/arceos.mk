################################################################################
#
# ArceOS
#
################################################################################

ARCEOS_VERSION = 94f31ed4f2d2bedc14f22e4b82dfe4000f010fc1
ARCEOS_SITE = https://github.com/arceos-org/arceos.git
ARCEOS_SITE_METHOD = git
ARCEOS_LICENSE = MIT
ARCEOS_LICENSE_FILES = LICENSE.GPLv3
JAILHOUSE_DEPENDENCIES = jailhouse

ifeq ($(BR2_PACKAGE_ARCEOS_PLATFORM_PHYTIUMPI),y)
BR2_PACKAGE_ARCEOS_PLATFORM = aarch64-phytium-pi
else ifeq ($(BR2_PACKAGE_ARCEOS_PLATFORM_RASPBERRYPI4B),y)
BR2_PACKAGE_ARCEOS_PLATFORM = aarch64-raspi4
endif

ifeq ($(BR2_PACKAGE_ARCEOS_EXAMPLE_HELLOWORLD),y)
BR2_PACKAGE_ARCEOS_EXAMPLE = helloworld
else ifeq ($(BR2_PACKAGE_ARCEOS_EXAMPLE_HELLOWORLD_C),y)
BR2_PACKAGE_ARCEOS_EXAMPLE = helloworld-c
endif

define ARCEOS_CONFIGURE_CMDS
	cp -f $(ARCEOS_PKGDIR)platforms/$(BR2_PACKAGE_ARCEOS_PLATFORM).toml $(@D)/platforms/
endef

define ARCEOS_BUILD_CMDS
	$(TARGET_MAKE_ENV) TARGET_DIR=$(@D)/target $(MAKE) -j1 -C $(@D) ARCH=$(BR2_ARCH) \
		PLATFORM=$(BR2_PACKAGE_ARCEOS_PLATFORM) A=examples/$(BR2_PACKAGE_ARCEOS_EXAMPLE)
endef

define ARCEOS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/examples/$(BR2_PACKAGE_ARCEOS_EXAMPLE)/*.bin \
		$(TARGET_DIR)/usr/local/libexec/jailhouse/demos/arceos.bin
endef

$(eval $(generic-package))