SUMMARY = "Mender server certificate"
LICENSE = "CLOSED"

# Inclure les fichiers locaux (mender.crt)
FILESEXTRAPATHS:prepend := "${THISDIR}/../files:"

SRC_URI = "file://mender.crt"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${sysconfdir}/mender
    install -m 0644 ${WORKDIR}/mender.crt ${D}${sysconfdir}/mender/server.crt
}

FILES:${PN} += "${sysconfdir}/mender/server.crt"
