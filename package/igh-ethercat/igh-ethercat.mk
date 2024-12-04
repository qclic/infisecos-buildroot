################################################################################
#
# igh-ethercat
#
################################################################################

IGH_ETHERCAT_VERSION = stable-1.5_v2.2
IGH_ETHERCAT_SITE = https://gitee.com/phytium_embedded/ether-cat.git
IGH_ETHERCAT_SITE_METHOD = git
IGH_ETHERCAT_AUTORECONF = YES

IGH_ETHERCAT_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_XENOMAI_COBALT),y)
IGH_ETHERCAT_DEPENDENCIES += xenomai
IGH_ETHERCAT_CONF_OPTS = \
	--with-linux-dir=$(LINUX_DIR) \
	--enable-generic \
	--enable-cadence \
	--enable-rtdm \
	--disable-rt-syslog \
	--with-xenomai-dir=$(STAGING_DIR)/usr/xenomai
else
IGH_ETHERCAT_CONF_OPTS = \
	--with-linux-dir=$(LINUX_DIR) \
	--enable-generic \
	--enable-cadence \
	--disable-rt-syslog
endif

IGH_ETHERCAT_CONF_OPTS += $(if $(BR2_PACKAGE_IGH_ETHERCAT_8139TOO),--enable-8139too,--disable-8139too)
IGH_ETHERCAT_CONF_OPTS += $(if $(BR2_PACKAGE_IGH_ETHERCAT_E100),--enable-e100,--disable-e100)
IGH_ETHERCAT_CONF_OPTS += $(if $(BR2_PACKAGE_IGH_ETHERCAT_E1000),--enable-e1000,--disable-e1000)
IGH_ETHERCAT_CONF_OPTS += $(if $(BR2_PACKAGE_IGH_ETHERCAT_E1000E),--enable-e1000e,--disable-e1000e)
IGH_ETHERCAT_CONF_OPTS += $(if $(BR2_PACKAGE_IGH_ETHERCAT_R8169),--enable-r8169,--disable-r8169)

define IGH_ETHERCAT_CREATE_CHANGELOG
	touch $(@D)/ChangeLog
	mkdir -p $(@D)/m4
	$(if $(BR2_PACKAGE_XENOMAI_COBALT),sed -i '3 i DESTDIR=$(STAGING_DIR)' $(STAGING_DIR)/usr/xenomai/bin/xeno-config)
endef
IGH_ETHERCAT_POST_PATCH_HOOKS += IGH_ETHERCAT_CREATE_CHANGELOG

IGH_ETHERCAT_MODULE_MAKE_OPTS = INSTALL_MOD_DIR="ethercat"

$(eval $(kernel-module))

define IGH_ETHERCAT_DO_NOT_LOAD_ON_BOOT
	mkdir -p $(TARGET_DIR)/etc/modprobe.d
	echo "# Do not load the 'ec_macb' module on boot." >> $(TARGET_DIR)/etc/modprobe.d/blacklist.conf
	echo "blacklist ec_macb" >> $(TARGET_DIR)/etc/modprobe.d/blacklist.conf
endef
IGH_ETHERCAT_POST_INSTALL_TARGET_HOOKS += IGH_ETHERCAT_DO_NOT_LOAD_ON_BOOT

$(eval $(autotools-package))
