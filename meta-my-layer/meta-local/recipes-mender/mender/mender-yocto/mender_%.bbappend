# Inclure les fichiers locaux (mender.conf et kernel)
FILESEXTRAPATHS:prepend := "${THISDIR}/../files:"

# Ajouter les fichiers à copier
SRC_URI:append = " \
    file://mender.conf \
    file://kernel \
"

# Installation des fichiers dans l’image finale
do_install:append() {
    # --- Installation du mender.conf ---
    install -d ${D}${sysconfdir}/mender
    install -m 0644 ${WORKDIR}/mender.conf ${D}${sysconfdir}/mender/mender.conf

    # --- Installation du module custom ---
    install -d ${D}${datadir}/mender/modules/v3
    install -m 0755 ${WORKDIR}/kernel ${D}${datadir}/mender/modules/v3/kernel
}
