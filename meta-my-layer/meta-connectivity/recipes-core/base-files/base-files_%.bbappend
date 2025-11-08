DESCRIPTION = "Custom /etc/hosts file with Mender server entries"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://hosts"

do_install:append() {
    install -m 0644 ${WORKDIR}/hosts ${D}${sysconfdir}/hosts
}
