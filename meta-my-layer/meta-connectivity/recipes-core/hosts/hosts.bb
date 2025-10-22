DESCRIPTION = "Custom /etc/hosts file with Mender server entries"
LICENSE = "CLOSED"

SRC_URI = "file://hosts"

do_install() {
    install -d ${D}/etc
    install -m 0644 ${WORKDIR}/hosts ${D}/etc/hosts
}

FILES:${PN} = "/etc/hosts"
