# Forcer le chemin patches avec version BSP 6.2.0
FILESEXTRAPATHS:prepend := "${THISDIR}/files:${THISDIR}/files/toradex-bsp-6.2.0:"

SRC_URI += "file://0001-Adapt-boot.cmd.in-to-Mender.patch"
