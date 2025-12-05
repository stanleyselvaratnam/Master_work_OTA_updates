# 1. On indique à Yocto de chercher des fichiers dans le dossier "files" de ce layer
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# 2. On ajoute vos fichiers sources à la liste (SRC_URI)
SRC_URI += " \
    file://single-file \
    file://directory \
"

# 3. On utilise do_install:append pour écraser les fichiers APRÈS l'installation standard
do_install:append() {
    # On écrase les scripts officiels par les vôtres
    install -m 0755 ${WORKDIR}/single-file ${D}${datadir}/mender/modules/v3/single-file
    install -m 0755 ${WORKDIR}/directory ${D}${datadir}/mender/modules/v3/directory
}