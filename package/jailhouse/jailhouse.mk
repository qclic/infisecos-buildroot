################################################################################
#
# jailhouse
#
################################################################################

JAILHOUSE_VERSION = f0a94319a96553b202b4d2e54a790524b6568f84
JAILHOUSE_SITE = https://gitee.com/itexp/jailhouse.git
JAILHOUSE_SITE_METHOD = git
JAILHOUSE_LICENSE = GPL-2.0
JAILHOUSE_LICENSE_FILES = COPYING
JAILHOUSE_DEPENDENCIES = \
	linux

JAILHOUSE_MAKE_OPTS = \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	ARCH="$(KERNEL_ARCH)" \
	KDIR="$(LINUX_DIR)" \
	DESTDIR="$(TARGET_DIR)" \
	INSTALL_MOD_DIR="jailhouse"

ifeq ($(BR2_PACKAGE_JAILHOUSE_HELPER_SCRIPTS),y)
JAILHOUSE_DEPENDENCIES += \
	python3 \
	host-python-mako \
	host-python-setuptools
JAILHOUSE_MAKE_OPTS += \
	HAS_PYTHON_MAKO="yes" \
	PYTHON_PIP_USABLE="yes"
else
JAILHOUSE_MAKE_OPTS += \
	HAS_PYTHON_MAKO="no" \
	PYTHON_PIP_USABLE="no"
endif

define JAILHOUSE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(JAILHOUSE_MAKE_OPTS) -C $(@D)

	$(if $(BR2_PACKAGE_JAILHOUSE_HELPER_SCRIPTS), \
		cd $(@D) && $(PKG_PYTHON_SETUPTOOLS_ENV) $(HOST_DIR)/bin/python setup.py build)
endef

define JAILHOUSE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(JAILHOUSE_MAKE_OPTS) -C $(@D) modules_install firmware_install tool_inmates_install
	$(TARGET_MAKE_ENV) $(MAKE) $(JAILHOUSE_MAKE_OPTS) -C $(@D)/tools src=$(@D)/tools install

	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/jailhouse
	$(INSTALL) -D -m 0644 $(@D)/configs/*/*.cell $(TARGET_DIR)/etc/jailhouse

	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/jailhouse/dtbs
	$(INSTALL) -D -m 0644 $(@D)/configs/*/dts/*.dtb $(TARGET_DIR)/etc/jailhouse/dtbs

	$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/local/libexec/jailhouse/demos
	$(INSTALL) -D -m 0755 $(@D)/inmates/demos/*/*.bin $(TARGET_DIR)/usr/local/libexec/jailhouse/demos

	$(if $(BR2_PACKAGE_JAILHOUSE_HELPER_SCRIPTS), \
		cd $(@D) && $(PKG_PYTHON_SETUPTOOLS_ENV) $(HOST_DIR)/bin/python setup.py install --no-compile $(PKG_PYTHON_SETUPTOOLS_INSTALL_TARGET_OPTS))
	$(and $(BR2_PACKAGE_JAILHOUSE_HELPER_SCRIPTS),$(BR2_ROOTFS_SKELETON_UBUNTU_FOCAL), \
		mkdir -p $(TARGET_DIR)/usr/local/lib/python3.8/dist-packages && \
		mv $(TARGET_DIR)/usr/lib/python3.10/site-packages/pyjailhouse $(TARGET_DIR)/usr/local/lib/python3.8/dist-packages && \
		mv $(TARGET_DIR)/usr/lib/python3.10/site-packages/pyjailhouse-0.12-py3.10.egg-info $(TARGET_DIR)/usr/local/lib/python3.8/dist-packages/pyjailhouse-0.12-py3.8.egg-info)
	$(and $(BR2_PACKAGE_JAILHOUSE_HELPER_SCRIPTS),$(BR2_ROOTFS_SKELETON_UBUNTU_JAMMY), \
		mkdir -p $(TARGET_DIR)/usr/local/lib/python3.10/dist-packages && \
		mv $(TARGET_DIR)/usr/lib/python3.10/site-packages/pyjailhouse $(TARGET_DIR)/usr/local/lib/python3.10/dist-packages && \
		mv $(TARGET_DIR)/usr/lib/python3.10/site-packages/pyjailhouse-0.12-py3.10.egg-info $(TARGET_DIR)/usr/local/lib/python3.10/dist-packages/pyjailhouse-0.12-py3.10.egg-info)
	$(and $(BR2_PACKAGE_JAILHOUSE_HELPER_SCRIPTS),$(BR2_ROOTFS_SKELETON_DEBIAN), \
		mkdir -p $(TARGET_DIR)/usr/local/lib/python3.9/dist-packages && \
		mv $(TARGET_DIR)/usr/lib/python3.10/site-packages/pyjailhouse $(TARGET_DIR)/usr/local/lib/python3.9/dist-packages && \
		mv $(TARGET_DIR)/usr/lib/python3.10/site-packages/pyjailhouse-0.12-py3.10.egg-info $(TARGET_DIR)/usr/local/lib/python3.9/dist-packages/pyjailhouse-0.12-py3.9.egg-info)
endef

$(eval $(generic-package))
