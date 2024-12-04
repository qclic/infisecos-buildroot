################################################################################
#
# rpmsg-demo
#
################################################################################

RPMSG_DEMO_SITE = https://gitee.com/phytium_embedded/phytium-embedded-docs/raw/master/open-amp
RPMSG_DEMO_SOURCE = rpmsg-demo.c

define RPMSG_DEMO_EXTRACT_CMDS
	cp $(RPMSG_DEMO_DL_DIR)/$(RPMSG_DEMO_SOURCE) $(@D)
endef

define RPMSG_DEMO_BUILD_CMDS
	$(TARGET_CC) -o $(@D)/rpmsg-demo $(@D)/$(RPMSG_DEMO_SOURCE)
endef

define RPMSG_DEMO_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/rpmsg-demo $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
