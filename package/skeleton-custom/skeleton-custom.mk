################################################################################
#
# skeleton-custom
#
################################################################################

# The skeleton can't depend on the toolchain, since all packages depends on the
# skeleton and the toolchain is a target package, as is skeleton.
# Hence, skeleton would depends on the toolchain and the toolchain would depend
# on skeleton.
SKELETON_CUSTOM_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_CUSTOM_ADD_SKELETON_DEPENDENCY = NO

SKELETON_CUSTOM_PROVIDES = skeleton

SKELETON_CUSTOM_INSTALL_STAGING = YES


ifeq ($(BR2_ROOTFS_SKELETON_UBUNTU)$(BR2_ROOTFS_SKELETON_DEBIAN),y)
define SKELETON_CUSTOM_BUILD_CMDS
	$(foreach s, $(call qstrip,$(BR2_ROOTFS_POST_CUSTOM_SKELETON_SCRIPT)), \
		@$(call MESSAGE,"Executing post-skeleton-custom script $(s)")$(sep) \
		$(EXTRA_ENV) $(s) $(@D) $(call qstrip,$(BR2_ROOTFS_POST_SCRIPT_ARGS))$(sep))
endef

define SKELETON_CUSTOM_INSTALL_TARGET_CMDS
        $(call SYSTEM_RSYNC,$(@D),$(TARGET_DIR))
        $(INSTALL) -m 0644 support/misc/target-dir-warning.txt \
                $(TARGET_DIR_WARNING_FILE)
        cd $(TARGET_DIR)/var && rm run && ln -sf ../run run && rm lock && ln -sf ../run/lock lock
endef

define SKELETON_CUSTOM_INSTALL_STAGING_CMDS
        $(call SYSTEM_RSYNC,$(@D),$(STAGING_DIR))
        cd $(STAGING_DIR)/var && rm run && ln -sf ../run run && rm lock && ln -sf ../run/lock lock
endef

define SKELETON_CUSTOM_REMOVE_PERMISSION_FOR_SSH_FILES
	if [ -d $(TARGET_DIR)/etc/ssh ]; then \
		chmod go-r $(TARGET_DIR)/etc/ssh/ssh_host_ecdsa_key; \
		chmod go-r $(TARGET_DIR)/etc/ssh/ssh_host_ed25519_key; \
		chmod go-r $(TARGET_DIR)/etc/ssh/ssh_host_rsa_key; \
	fi
endef
SKELETON_CUSTOM_POST_INSTALL_TARGET_HOOKS += SKELETON_CUSTOM_REMOVE_PERMISSION_FOR_SSH_FILES

else

SKELETON_CUSTOM_PATH = $(call qstrip,$(BR2_ROOTFS_SKELETON_CUSTOM_PATH))
ifeq ($(BR2_PACKAGE_SKELETON_CUSTOM)$(BR_BUILDING),yy)
ifeq ($(SKELETON_CUSTOM_PATH),)
$(error No path specified for the custom skeleton)
endif
endif

# For a merged /usr, ensure that /lib, /bin and /sbin and their /usr
# counterparts are appropriately setup as symlinks ones to the others.
ifeq ($(BR2_ROOTFS_MERGED_USR),y)
SKELETON_CUSTOM_NOT_MERGED_USR_DIRS = \
	$(shell support/scripts/check-merged-usr.sh $(SKELETON_CUSTOM_PATH))
endif # merged /usr

ifeq ($(BR2_PACKAGE_SKELETON_CUSTOM)$(BR_BUILDING),yy)
ifneq ($(SKELETON_CUSTOM_NOT_MERGED_USR_DIRS),)
$(error The custom skeleton in $(SKELETON_CUSTOM_PATH) is not \
	using a merged /usr for the following directories: \
	$(SKELETON_CUSTOM_NOT_MERGED_USR_DIRS))
endif
endif

# The target-dir-warning file and the lib{32,64} symlinks are the only
# things we customise in the custom skeleton.
define SKELETON_CUSTOM_INSTALL_TARGET_CMDS
	$(call SYSTEM_RSYNC,$(SKELETON_CUSTOM_PATH),$(TARGET_DIR))
	$(call SYSTEM_USR_SYMLINKS_OR_DIRS,$(TARGET_DIR))
	$(call SYSTEM_LIB_SYMLINK,$(TARGET_DIR))
	$(INSTALL) -m 0644 support/misc/target-dir-warning.txt \
		$(TARGET_DIR_WARNING_FILE)
endef

# For the staging dir, we don't really care what we install, but we
# need the /lib and /usr/lib appropriately setup. Since we ensure,
# above, that they are correct in the skeleton, we can simply copy the
# skeleton to staging.
define SKELETON_CUSTOM_INSTALL_STAGING_CMDS
	$(call SYSTEM_RSYNC,$(SKELETON_CUSTOM_PATH),$(STAGING_DIR))
	$(call SYSTEM_USR_SYMLINKS_OR_DIRS,$(STAGING_DIR))
	$(call SYSTEM_LIB_SYMLINK,$(STAGING_DIR))
endef
endif # BR2_ROOTFS_SKELETON_CUSTOM_SITE
$(eval $(generic-package))
