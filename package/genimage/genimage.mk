################################################################################
#
# genimage
#
################################################################################

GENIMAGE_VERSION = 15
GENIMAGE_SOURCE = genimage-$(GENIMAGE_VERSION).tar.xz
GENIMAGE_SITE = https://github.com/pengutronix/genimage/releases/download/v$(GENIMAGE_VERSION)
HOST_GENIMAGE_DEPENDENCIES = host-pkgconf host-libconfuse host-p7zip 
GENIMAGE_LICENSE = GPL-2.0
GENIMAGE_LICENSE_FILES = COPYING

$(eval $(host-autotools-package))
