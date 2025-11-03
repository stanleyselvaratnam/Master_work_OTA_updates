# Forcer le chemin des patches fixes la version BSP
FILESEXTRAPATHS:prepend:mender-uboot := "${THISDIR}/files:${THISDIR}/files/toradex-bsp-6.2.0:"

include ${@mender_feature_is_enabled("mender-uboot","recipes-bsp/u-boot/u-boot-mender.inc","",d)}

MENDER_UBOOT_AUTO_CONFIGURE:mender-uboot = "0"
BOOTENV_SIZE:mender-uboot = "0x4000"
MENDER_RESERVED_SPACE_BOOTLOADER_DATA:mender-uboot:colibri-imx6ull = "0x40000"
BOOTENV_SIZE:mender-uboot:colibri-imx6ull = "0x20000"

PROVIDES += "${@mender_feature_is_enabled("mender-uboot","u-boot-default-env","",d)}"
PROVIDES += "${@mender_feature_is_enabled("mender-uboot","u-boot","",d)}"
RPROVIDES:${PN} += "${@mender_feature_is_enabled("mender-uboot","u-boot","",d)}"
PROVIDES += "${@mender_feature_is_enabled("mender-uboot","u-boot-default-env","",d)}"

# Patches appliqués forcés sur le Verdine imx8mp BSP 6.2.0
SRC_URI:append:mender-uboot = " \
    file://0001-Integration-of-Mender-boot-code-into-toradex-U-Boot.patch \
    file://toradex-bsp-6.2.0/verdin-imx8mp/0001-configs-toradex-board-specific-mender-integration.patch \
    file://toradex-bsp-6.2.0/verdin-imx8mp/0001-Use-mender_dtb_name-for-fdtfile.patch \
"

# Patch read-only-rootfs seulement pour colibri-imx6ull, garder comme tel
SRC_URI:append:mender-uboot:colibri-imx6ull = " file://0002-use-read-only-rootfs.patch "

# Supprimer patch kirkstone incompatible et forcer patch toradex
SRC_URI:remove:mender-uboot = " file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch "
SRC_URI:append:mender-uboot = " file://0001-Integration-of-Mender-boot-code-into-toradex-U-Boot.patch "
