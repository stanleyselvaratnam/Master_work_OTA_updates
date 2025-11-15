SUMMARY = "Generate custom boot.scr from boot.cmd.in"
DESCRIPTION = "Generate boot.scr into deploy/images so it appears with other deploy files"
LICENSE = "CLOSED"

SRC_URI = "file://boot.cmd.in"

S = "${WORKDIR}"

DEPENDS = "u-boot-mkimage-native"

inherit deploy

do_configure() {
    cp ${WORKDIR}/boot.cmd.in ${WORKDIR}/boot.cmd
}

do_compile() {
    mkimage -A arm64 -O linux -T script -C none \
        -a 0 -e 0 \
        -n "Custom U-Boot Script" \
        -d ${WORKDIR}/boot.cmd \
        ${WORKDIR}/boot.scr
}

do_install() {
    # Pas d'installation dans le rootfs
    :
}

do_deploy() {
    echo "DEPLOYDIR=${DEPLOYDIR}"
    # Crée le dossier de déploiement si besoin
    install -d ${DEPLOYDIR}
    # Copie boot.scr dans deploy/images/<machine>/
    install -m 0644 ${WORKDIR}/boot.scr ${DEPLOYDIR}/boot.scr
}
addtask deploy after do_compile
