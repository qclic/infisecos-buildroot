################################################################################
#
# aarch64-none-elf-toolchain
#
################################################################################

AARCH64_NONE_ELF_TOOLCHAIN_VERSION = 10.3-2021.07
AARCH64_NONE_ELF_TOOLCHAIN_SITE = https://developer.arm.com/-/media/Files/downloads/gnu-a/$(AARCH64_NONE_ELF_TOOLCHAIN_VERSION)/binrel
AARCH64_NONE_ELF_TOOLCHAIN_SOURCE = gcc-arm-$(AARCH64_NONE_ELF_TOOLCHAIN_VERSION)-x86_64-aarch64-none-elf.tar.xz
AARCH64_NONE_ELF_TOOLCHAIN_LICENSE = GPL-3.0+

HOST_AARCH64_NONE_ELF_TOOLCHAIN_INSTALL_DIR = $(HOST_DIR)/opt/aarch64-none-elf

define HOST_AARCH64_NONE_ELF_TOOLCHAIN_INSTALL_CMDS
	rm -rf $(HOST_AARCH64_NONE_ELF_TOOLCHAIN_INSTALL_DIR)
	mkdir -p $(HOST_AARCH64_NONE_ELF_TOOLCHAIN_INSTALL_DIR)
	cp -rf $(@D)/* $(HOST_AARCH64_NONE_ELF_TOOLCHAIN_INSTALL_DIR)/

	mkdir -p $(HOST_DIR)/bin
	cd $(HOST_DIR)/bin && \
	for i in ../opt/aarch64-none-elf/bin/*; do \
		ln -sf $$i; \
	done
endef

$(eval $(host-generic-package))
